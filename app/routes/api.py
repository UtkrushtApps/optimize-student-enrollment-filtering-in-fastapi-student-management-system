from fastapi import APIRouter, HTTPException, Query
from app.schemas.schemas import Student, StudentWithStatus
from app.database import get_db_connection
from typing import List, Optional

router = APIRouter()

@router.get('/students', response_model=List[Student])
def list_students():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT id, name, email FROM students ORDER BY id ASC')
    students = [Student(id=row[0], name=row[1], email=row[2]) for row in cur.fetchall()]
    cur.close()
    conn.close()
    return students

@router.get('/students/by_course', response_model=List[StudentWithStatus])
def students_by_course(course_id: int, status: Optional[str] = Query(None)):
    conn = get_db_connection()
    cur = conn.cursor()
    # Intentionally suboptimal: LEFT JOIN without indexes or filter pushdown
    if status:
        cur.execute('''
            SELECT s.id, s.name, s.email, e.status
            FROM students s
            LEFT JOIN enrollments e ON s.id = e.student_id
            WHERE e.course_id = %s AND e.status = %s
            ORDER BY s.id ASC
        ''', (course_id, status))
    else:
        cur.execute('''
            SELECT s.id, s.name, s.email, e.status
            FROM students s
            LEFT JOIN enrollments e ON s.id = e.student_id
            WHERE e.course_id = %s
            ORDER BY s.id ASC
        ''', (course_id,))
    results = [StudentWithStatus(id=row[0], name=row[1], email=row[2], status=row[3]) for row in cur.fetchall()]
    cur.close()
    conn.close()
    return results
