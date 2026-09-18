*/
tablolarımız :
department
student
course 
ilişkilerimiz :
department<->student 1:N
department<->course 1:N 
1:N ilişkileri foreign key ile sağla
course<->student M:N bu ilişki için enrollments tablosu kullanılmalı
*/

PRAGMA foreign_keys = ON;

CREATE TABLE departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_code TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL
);

CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    department_id INTEGER NOT NULL, 
    FOREIGN KEY (department_id) REFERENCES departments(id) -- student<->department --
);


CREATE TABLE courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_id INTEGER NOT NULL,
    course_code TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE enrollments (   -- M:N için gerekli köprü 
    student_id INTEGER NOT NULL,  
    course_id INTEGER NOT NULL,  

    PRIMARY KEY (student_id, course_id),  

    FOREIGN KEY (student_id)  
        REFERENCES students(id),  

    FOREIGN KEY (course_id)  
        REFERENCES courses(id)  
);