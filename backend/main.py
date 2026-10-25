
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional
from pathlib import Path
from dotenv import load_dotenv
import mysql.connector
import uuid
import os

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), ".env"))

app = FastAPI()

# Store uploaded hazard photos in the backend/uploads folder.
UPLOAD_DIR = Path(__file__).resolve().parent / "uploads"
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

app.mount(
    "/uploads",
    StaticFiles(directory=str(UPLOAD_DIR)),
    name="uploads"
)

# CORS settings for local development and Flutter web.
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5000",
        "http://127.0.0.1:5000",
        "http://localhost:8080",
        "http://127.0.0.1:8080",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
    ],
    allow_origin_regex=r"https?://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv("MYSQL_PASSWORD"),
    database="GROUP_5A"
)


class RegisterRequest(BaseModel):
    first_name: str
    last_name: str
    email: str
    mobile_number: str
    password: str
    username: str


class LoginRequest(BaseModel):
    email: str
    password: str


class HazardReportRequest(BaseModel):
    title: str
    category: str
    severity: int = Field(ge=1, le=5)
    description: str = ""
    location: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None


@app.get("/")
def home():
    return {"message": "Fixit Backend works!"}


@app.post("/register")
def register(user: RegisterRequest):
    cursor = db.cursor()

    try:
        cursor.execute(
            """
            INSERT INTO SIGN_IN
            (FIRST_NAME, LAST_NAME, EMAIL, MOBILE_NUMBER,
             PASSWORD, USERNAME, CREATED_AT)
            VALUES (%s, %s, %s, %s, %s, %s, NOW())
            """,
            (
                user.first_name,
                user.last_name,
                user.email,
                user.mobile_number,
                user.password,
                user.username
            )
        )

        cursor.execute(
            """
            INSERT INTO LOGIN (EMAIL, PASSWORD)
            VALUES (%s, %s)
            """,
            (user.email, user.password)
        )

        db.commit()

        return {
            "message": "User registered successfully!",
            "email": user.email,
            "username": user.username
        }

    except Exception:
        db.rollback()
        raise

    finally:
        cursor.close()


@app.post("/login")
def login(user: LoginRequest):
    cursor = db.cursor()

    try:
        cursor.execute(
            "SELECT * FROM LOGIN WHERE EMAIL = %s AND PASSWORD = %s",
            (user.email, user.password)
        )

        result = cursor.fetchone()

        if result:
            return {
                "message": "User logged in successfully!",
                "email": user.email
            }

        return {"message": "Invalid email or password"}

    finally:
        cursor.close()


@app.post("/reports")
def create_report(report: HazardReportRequest):
    cursor = db.cursor()

    try:
        cursor.execute(
            """
            INSERT INTO HAZARD_REPORTS
            (TITLE, CATEGORY, SEVERITY, DESCRIPTION, LOCATION,
             LATITUDE, LONGITUDE, STATUS, LATEST_UPDATE)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (
                report.title,
                report.category,
                report.severity,
                report.description,
                report.location,
                report.latitude,
                report.longitude,
                "Submitted",
                "Your report has been received."
            )
        )

        report_id = cursor.lastrowid

        cursor.execute(
            """
            INSERT INTO REPORT_STATUS_HISTORY
            (REPORT_ID, STATUS, UPDATE_MESSAGE, UPDATED_BY)
            VALUES (%s, %s, %s, %s)
            """,
            (
                report_id,
                "Submitted",
                "Your report has been received.",
                "System"
            )
        )

        db.commit()

        return {
            "message": "Report submitted successfully",
            "report_id": report_id,
            "status": "Submitted"
        }

    except Exception:
        db.rollback()
        raise

    finally:
        cursor.close()


@app.get("/reports")
def get_reports():
    cursor = db.cursor(dictionary=True)

    try:
        cursor.execute(
            """
            SELECT ID, TITLE, CATEGORY, SEVERITY, DESCRIPTION,
                   LOCATION, LATITUDE, LONGITUDE, STATUS,
                   LATEST_UPDATE, ASSIGNED_DEPARTMENT,
                   CREATED_AT, UPDATED_AT, RESOLVED_AT,
                   IMAGE_PATH
            FROM HAZARD_REPORTS
            ORDER BY CREATED_AT DESC
            """
        )

        reports = cursor.fetchall()

        for report in reports:
            cursor.execute(
                """
                SELECT STATUS, UPDATE_MESSAGE, UPDATED_BY, CREATED_AT
                FROM REPORT_STATUS_HISTORY
                WHERE REPORT_ID = %s
                ORDER BY CREATED_AT ASC, ID ASC
                """,
                (report["ID"],)
            )

            report["history"] = cursor.fetchall()

        return reports

    finally:
        cursor.close()


@app.post("/reports/{report_id}/image")
async def upload_report_image(
    report_id: int,
    image: UploadFile = File(...)
):
    # Accept common JPEG, PNG, and WebP MIME types.
    allowed_types = {
        "image/jpeg": ".jpg",
        "image/jpg": ".jpg",
        "image/pjpeg": ".jpg",
        "image/png": ".png",
        "image/x-png": ".png",
        "image/webp": ".webp",
    }

    # First check MIME type, then fall back to the filename extension.
    content_type = (image.content_type or "").lower().split(";")[0].strip()
    extension = allowed_types.get(content_type)

    if extension is None:
        file_extension = Path(image.filename or "").suffix.lower()
        allowed_extensions = {
            ".jpg": ".jpg",
            ".jpeg": ".jpg",
            ".png": ".png",
            ".webp": ".webp",
        }
        extension = allowed_extensions.get(file_extension)

    if extension is None:
        raise HTTPException(
            status_code=400,
            detail="Upload a JPG, PNG, or WEBP image."
        )

    contents = await image.read()

    if not contents:
        raise HTTPException(
            status_code=400,
            detail="The image is empty."
        )

    if len(contents) > 5 * 1024 * 1024:
        raise HTTPException(
            status_code=413,
            detail="Image size must be 5 MB or less."
        )

    filename = f"{uuid.uuid4().hex}{extension}"
    file_path = UPLOAD_DIR / filename
    cursor = db.cursor()

    try:
        cursor.execute(
            "SELECT ID FROM HAZARD_REPORTS WHERE ID = %s",
            (report_id,)
        )

        if cursor.fetchone() is None:
            raise HTTPException(
                status_code=404,
                detail="Hazard report not found."
            )

        file_path.write_bytes(contents)
        image_path = f"/uploads/{filename}"

        cursor.execute(
            """
            UPDATE HAZARD_REPORTS
            SET IMAGE_PATH = %s
            WHERE ID = %s
            """,
            (image_path, report_id)
        )

        db.commit()

        return {
            "message": "Image uploaded successfully.",
            "report_id": report_id,
            "image_path": image_path
        }

    except HTTPException:
        db.rollback()
        if file_path.exists():
            file_path.unlink()
        raise

    except Exception:
        db.rollback()
        if file_path.exists():
            file_path.unlink()

        raise HTTPException(
            status_code=500,
            detail="Could not save the report image."
        )

    finally:
        cursor.close()
