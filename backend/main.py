from fastapi import FastAPI
from pydantic import BaseModel
import mysql.connector

app=FastAPI()
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Kishore@1979",
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
    return {
        "message": "User registered successfully!",
        "first_name": user.first_name,
        "last_name": user.last_name,
        "email": user.email,
        "mobile_number": user.mobile_number,
        "username": user.username
    }
@app.post("/login")
def login(user: LoginRequest):
    return{"message":"User logged in successfully!","email":user.email} 