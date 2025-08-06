from pydantic import BaseModel
from typing import Optional

class Student(BaseModel):
    id: int
    name: str
    email: str

class StudentWithStatus(BaseModel):
    id: int
    name: str
    email: str
    status: Optional[str] = None
