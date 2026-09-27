from fastapi import FastAPI
from pydantic import BaseModel

app=FastAPI()

class RegisterRequest(BaseModel):
    name: str
    email: str
    password: str
    phone: str

class LoginRequest(BaseModel):
    email: str
    password: str


@app.get("/")
def home():
    return{"message":"Fixit Backend works!"}

@app.post("/register")
def register(user: RegisterRequest):
    return{"message":"User registered successfully!","name":user.name,"email":user.email,"phone":user.phone}

@app.post("/login")
def login(user: LoginRequest):
    return{"message":"User logged in successfully!","email":user.email} 