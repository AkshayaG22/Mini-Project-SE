from fastapi import FastAPI
from pydantic import BaseModel
import mysql.connector
import os
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), ".env"))
# Keep your other existing imports here

app = FastAPI()

# Replace your old CORS block with this
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

# Keep all your existing database connection code and API endpoints below
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


@app.get("/")
def home():
    return{"message":"Fixit Backend works!"}

@app.post("/register")
def register(user: RegisterRequest):

    cursor = db.cursor()

    cursor.execute("""
        INSERT INTO SIGN_IN
        (FIRST_NAME, LAST_NAME, EMAIL, MOBILE_NUMBER, PASSWORD, USERNAME, CREATED_AT)
        VALUES (%s, %s, %s, %s, %s, %s, NOW())
    """, (
        user.first_name,
        user.last_name,
        user.email,
        user.mobile_number,
        user.password,
        user.username
    ))

    cursor.execute("""
        INSERT INTO LOGIN (EMAIL, PASSWORD)
        VALUES (%s, %s)
    """, (
        user.email,
        user.password
    ))

    db.commit()
    cursor.close()

    return {
        "message": "User registered successfully!",
        "email": user.email,
        "username": user.username
    }
@app.post("/login")
def login(user: LoginRequest):

    cursor = db.cursor()

    cursor.execute(
        "SELECT * FROM LOGIN WHERE EMAIL = %s AND PASSWORD = %s",
        (user.email, user.password)
    )

    result = cursor.fetchone()

    cursor.close()

    if result:
        return {
            "message": "User logged in successfully!",
            "email": user.email
        }
    else:
        return {
            "message": "Invalid email or password"
        }

    
from typing import Optional
from pydantic import Field


class HazardReportRequest(BaseModel):
    title: str
    category: str
    severity: int = Field(ge=1, le=5)
    description: str = ""
    location: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None


@app.post("/reports")
def create_report(report: HazardReportRequest):
    cursor = db.cursor()

    try:
        cursor.execute("""
            INSERT INTO HAZARD_REPORTS
            (TITLE, CATEGORY, SEVERITY, DESCRIPTION, LOCATION,
             LATITUDE, LONGITUDE, STATUS, LATEST_UPDATE)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            report.title,
            report.category,
            report.severity,
            report.description,
            report.location,
            report.latitude,
            report.longitude,
            "Submitted",
            "Your report has been received."
        ))

        report_id = cursor.lastrowid

        cursor.execute("""
            INSERT INTO REPORT_STATUS_HISTORY
            (REPORT_ID, STATUS, UPDATE_MESSAGE, UPDATED_BY)
            VALUES (%s, %s, %s, %s)
        """, (
            report_id,
            "Submitted",
            "Your report has been received.",
            "System"
        ))

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
        cursor.execute("""
            SELECT ID, TITLE, CATEGORY, SEVERITY, DESCRIPTION,
                   LOCATION, LATITUDE, LONGITUDE, STATUS,
                   LATEST_UPDATE, ASSIGNED_DEPARTMENT,
                   CREATED_AT, UPDATED_AT, RESOLVED_AT
            FROM HAZARD_REPORTS
            ORDER BY CREATED_AT DESC
        """)

        reports = cursor.fetchall()

        for report in reports:
            cursor.execute("""
                SELECT STATUS, UPDATE_MESSAGE, UPDATED_BY, CREATED_AT
                FROM REPORT_STATUS_HISTORY
                WHERE REPORT_ID = %s
                ORDER BY CREATED_AT ASC, ID ASC
            """, (report["ID"],))

            report["history"] = cursor.fetchall()

        return reports

    finally:
        cursor.close()
