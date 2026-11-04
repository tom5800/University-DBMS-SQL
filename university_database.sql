CREATE DATABASE universityDB;
USE universityDB;
CREATE TABLE students ( 
	student_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(50)
    );
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    in_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
);
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    department_id INT,
    instructor_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL,
    FOREIGN KEY (instructor_id)
        REFERENCES instructors(instructor_id)
        
);
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade DECIMAL(5,2),
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE,
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        );
	
CREATE TABLE class_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    instructor_id INT NOT NULL,
    classroom VARCHAR(50),
    day_of_week VARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE,
    FOREIGN KEY (instructor_id)
        REFERENCES instructors(instructor_id)
        ON DELETE CASCADE
        );
        
ALTER TABLE students
MODIFY department_id INT;

ALTER TABLE students
ADD CONSTRAINT fk_student_department
FOREIGN KEY (department_id)
REFERENCES departments(department_id)
ON DELETE SET NULL;

INSERT INTO departments (department_name)
VALUES
('Computer Science'),
('Artificial Intelligence'),
('Electronics'),
('Mechanical Engineering'),
('Civil Engineering');

INSERT INTO students (student_id, name, department_id)
VALUES
(1, 'Tom Joyal', 2),
(2, 'Arun Kumar', 1),
(3, 'Anu Joseph', 2),
(4, 'Rahul Das', 3),
(5, 'Meera Nair', 4),
(6, 'John Paul', 1),
(7, 'Sneha Roy', 5),
(8, 'Vishnu Raj', 2),
(9, 'Amal George', 3),
(10, 'Neha Thomas', 1);

INSERT INTO instructors
(in_name, email, department_id)
VALUES
('John Mathew', 'john@university.com', 1),
('Anita Sharma', 'anita@university.com', 2),
('David Thomas', 'david@university.com', 3),
('Priya Nair', 'priya@university.com', 4),
('Rahul Menon', 'rahul@university.com', 5);

INSERT INTO courses
(course_title, department_id, instructor_id)
VALUES
('Database Management Systems', 1, 1),
('Python Programming', 1, 1),
('Machine Learning', 2, 2),
('Deep Learning', 2, 2),
('Digital Electronics', 3, 3),
('Computer Networks', 3, 3),
('Thermodynamics', 4, 4),
('Structural Engineering', 5, 5);

INSERT INTO enrollments
(student_id, course_id, grade)
VALUES
(1, 3, 85.00),
(1, 4, 90.00),
(2, 1, 78.00),
(2, 2, 82.00),
(3, 3, 88.00),
(3, 4, 92.00),
(4, 5, 75.00),
(4, 6, 80.00),
(5, 7, 89.00),
(6, 1, 91.00),
(6, 2, 86.00),
(7, 8, 77.00),
(8, 3, 95.00),
(9, 5, 83.00),
(10, 1, 87.00);



INSERT INTO class_schedule
(course_id, instructor_id, classroom, day_of_week,
 start_time, end_time)
VALUES
(1, 1, 'Room 101', 'Monday', '09:00:00', '10:00:00'),
(2, 1, 'Room 102', 'Tuesday', '10:00:00', '11:00:00'),
(3, 2, 'Room 201', 'Monday', '11:00:00', '12:00:00'),
(4, 2, 'Room 202', 'Wednesday', '09:00:00', '10:00:00'),
(5, 3, 'Room 301', 'Thursday', '10:00:00', '11:00:00'),
(6, 3, 'Room 302', 'Friday', '11:00:00', '12:00:00'),
(7, 4, 'Room 401', 'Tuesday', '09:00:00', '10:00:00'),
(8, 5, 'Room 501', 'Wednesday', '11:00:00', '12:00:00');

SELECT * FROM departments;

SELECT * FROM students;

SELECT * FROM instructors;

SELECT * FROM courses;

SELECT * FROM enrollments;

SELECT * FROM class_schedule;


ALTER TABLE students
ADD phone VARCHAR(15);
UPDATE students
SET phone = '9876543210'
WHERE student_id = 1;

SELECT * FROM students
WHERE student_id = 1;

DELETE FROM courses
WHERE course_id = 8;

ALTER TABLE enrollments
DROP FOREIGN KEY enrollments_ibfk_2;

ALTER TABLE enrollments
ADD CONSTRAINT fk_enrollment_course
FOREIGN KEY (course_id)
REFERENCES courses(course_id)
ON DELETE CASCADE;
DELETE FROM courses
WHERE course_id = 8;

SELECT * FROM courses;

INSERT INTO enrollments
(student_id, course_id, grade)
VALUES
(1, 1, NULL);

SELECT * FROM enrollments;

SELECT *
FROM students
INNER JOIN departments
ON students.department_id = departments.department_id;

SELECT *
FROM courses
INNER JOIN instructors
ON courses.instructor_id = instructors.instructor_id
WHERE instructors.instructor_id = 2;

SELECT *
FROM students
INNER JOIN enrollments
ON students.student_id = enrollments.student_id
INNER JOIN courses
ON enrollments.course_id = courses.course_id
WHERE courses.course_id = 3;


SELECT
    departments.department_name,
    COUNT(students.student_id) AS total_students
FROM departments
LEFT JOIN students
ON departments.department_id = students.department_id
GROUP BY departments.department_id, departments.department_name;

SELECT
    departments.department_name,
    COUNT(students.student_id) AS total_students
FROM departments
INNER JOIN students
ON departments.department_id = students.department_id
GROUP BY departments.department_id, departments.department_name
ORDER BY total_students DESC;

SELECT student_id, name
FROM students
WHERE student_id NOT IN (
    SELECT student_id
    FROM enrollments
);

SELECT instructor_id, in_name
FROM instructors
WHERE instructor_id IN (
	SELECT instructor_id
    FROM courses
    GROUP BY instructor_id
    HAVING COUNT(course_id) = (
		SELECT MAX(course_count)
        FROM (
			SELECT COUNT(course_id) AS course_count
            FROM courses
            GROUP BY instructor_id
            ) AS temp
	)
);

CREATE INDEX idx_student_course
ON enrollments (student_id,course_id);
SHOW INDEX FROM enrollments;

SELECT * FROM enrollments;

DESCRIBE enrollments;

CREATE INDEX idx_student_name
ON students(name);

CREATE INDEX idx_course_title
ON courses(course_title);

SHOW INDEX FROM enrollments;
SHOW INDEX FROM students;
SHOW INDEX FROM courses;

CREATE VIEW student_performance AS
SELECT students.name AS student_name,courses.course_title,enrollments.grade
FROM enrollments
INNER JOIN students
	ON enrollments.student_id = students.student_id
INNER JOIN courses
	ON enrollments.course_id = courses.course_id;
    
SELECT * FROM student_performance;