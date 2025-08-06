import psycopg2
from psycopg2.extras import RealDictCursor

def get_db_connection():
    conn = psycopg2.connect(
        host='db',
        database='studentdb',
        user='studentuser',
        password='studentpass'
    )
    return conn
