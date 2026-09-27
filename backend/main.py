from fastapi import FastAPI
from pydantic import BaseModel
import mysql.connector
import os
from dotenv import load_dotenv
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), ".env"))

app=FastAPI()
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