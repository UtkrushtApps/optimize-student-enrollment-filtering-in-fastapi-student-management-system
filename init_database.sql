-- Inefficient schema for demonstration: missing useful indexes, suboptimal join columns
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL
);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    status VARCHAR(20), -- e.g., 'active' or 'inactive'
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT INTO students (name, email) VALUES
  ('Alice','alice@example.com'),
  ('Bob','bob@example.com'),
  ('Carol','carol@example.com'),
  ('Diana','diana@example.com'),
  ('Edward','edward@example.com');

INSERT INTO courses (title) VALUES
  ('Mathematics'),
  ('Science'),
  ('Literature');

-- Sample enrollments: purposely with lots of duplication for performance testing
INSERT INTO enrollments (student_id, course_id, status) VALUES
  (1, 1, 'active'), (2, 1, 'active'), (3, 2, 'inactive'),
  (1, 2, 'active'), (4, 1, 'inactive'), (5, 2, 'active');

-- Add in more enrollments to simulate realistic data and nudge candidate to focus on perf
DO $$
DECLARE
    i INTEGER := 6;
BEGIN
    WHILE i <= 1000 LOOP
        INSERT INTO students (name, email) VALUES
          ('Student' || i, 'student' || i || '@example.com');
        INSERT INTO enrollments (student_id, course_id, status)
        VALUES (i, ((i % 3) + 1), CASE WHEN (i % 2) = 0 THEN 'active' ELSE 'inactive' END);
        i := i + 1;
    END LOOP;
END $$;