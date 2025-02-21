CREATE TABLE `university`.`instructors` (`instructor_id` INT NOT NULL ,
 `first_name` VARCHAR(50) NOT NULL , 
  `last_name` VARCHAR(50) NOT NULL , 
  `email` VARCHAR(18) NOT NULL , 
  `hire_date` DATE NOT NULL , 
  `department` VARCHAR(18) NOT NULL , 
  PRIMARY KEY (`instructor_id`)) ENGINE = InnoDB;

----------------------------------------------------------------
CREATE TABLE university. Enrollments (
enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
grade VARCHAR(2),
CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES university. Students(student_id) ON DELETE CASCADE,
CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES university. Courses(course_id) ON DELETE CASCADE
);

1----------------------------------------------------------------
INSERT INTO students (first_name, last_name, email, date_of_birth, gender, major, enrollment_year) VALUES
('1','Omar', 'Al-Masri', 'omar.masri@example.com', '2002-05-14', 'Male', 'Computer Science', 2021),
('2','Laila', 'Hassan', 'laila.hassan@example.com', '2003-08-22', 'Female', 'Business Administration',
2022),
('3','Ahmed', 'Khaled', 'ahmed. khaled@example.com', '2001-12-30', 'Male', 'Electrical Engineering', 2020),
('4','Sara', 'Youssef', 'sara.youssef@example.com', '2004-03-18', 'Female', 'Medicine', 2023),
('5','Yassin', 'Nasser', 'yassin.nasser@example.com', '2002-09-25', 'Male', 'Mechanical Engineering',
2021),
('6','Hana', 'Tariq', 'hana.tariq@example.com', '2003-06-11', 'Female', 'Architecture', 2022),
('7','Mohammed', 'Saleh', 'mohammed. saleh@example.com', '2001-11-05', 'Male', 'Civil Engineering', 2020),
('8','Amina', 'Fadel', 'amina. fadel@example.com', '2004-01-27', 'Female', 'Law', 2023),
('9','Kareem', 'Samir', 'kareem. samir@example.com', '2002-07-09', 'Male', 'Software Engineering', 2021),
('10','Nour', 'Adel', 'nour. adel@example.com', '2003-04-15', 'Female', 'Psychology', 2022);

2----------------------------------------------------------------
INSERT INTO courses (course_id , course_name, course_code, credits, department) VALUES
('10','Introduction to Computer Science', 'CS101', 3, 'Computer Science'),
('20','Principles of Marketing', 'MKT201', 3, 'Business Administration'),
('30','Circuit Analysis', 'EE205', 4, 'Electrical Engineering'),
('40','Structural Mechanics', 'CE310', 4, 'Civil Engineering'),
('50','Psychological Theories', 'PSY220', 3, 'Psychology' );

3----------------------------------------------------------------
INSERT INTO instructors (instructor_id, first_name, last_name, email, hire_date, department) VALUES
('101','Ali', 'Hamdan', 'ali. hamdan@example.com', '2015-08-12', 'Computer Science' ),
('102','Mona', 'Saeed', 'mona. saeed@example.com', '2017-04-25', 'Business Administration' ),
('103','Khaled', 'Rashid', 'khaled.rashid@example.com', '2012-09-18', 'Electrical Engineering' ),
('104','Huda', 'Karim', 'huda.karim@example.com', '2019-11-03', 'Civil Engineering'),
('105','Tariq', 'Zayed', 'tariq.zayed@example.com', '2016-06-20', 'Psychology');

4----------------------------------------------------------------
INSERT INTO enrollments (student_id, course_id, grade) VALUES
('503','1', '10', 'A'),
 ('504','2', '20', 'B'),
 ('505','3', '30', 'C'),
 ('506','4', '40', 'A'),
 ('507','5', '50', 'B'),
 ('508','6', '10', 'C'),
 ('509','7', '20', 'A'),
 ('510','8', '30', 'B'),
 ('511','9', '40', 'C'),
 ('512','10', '50', 'A');

1----------------------------------------------------------------

SELECT * FROM students;

2----------------------------------------------------------------

SELECT COUNT(*) AS total_courses FROM courses;

3----------------------------------------------------------------

SELECT students.student_id FROM enrollment
JOIN students ON enrollment.student_id = students.student_id
WHERE enrollment.course_id = 20;

4----------------------------------------------------------------

SELECT email 
FROM instructors 
WHERE department = 'Computer Science';

1----------------------------------------------------------------

SELECT 
    courses.course_id, 
    courses.course_name, 
    COUNT(enrollment.student_id) AS total_students
FROM enrollment
JOIN courses ON enrollment.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name
ORDER BY total_students DESC;

2----------------------------------------------------------------

SELECT student_id 
FROM enrollment 
WHERE grade = 'A';

3----------------------------------------------------------------

SELECT 
    courses.course_id, 
    courses.course_name, 
    instructors.instructor_id, 
    instructors.first_name, 
    instructors.last_name, 
    course_instructors.semester
FROM course_instructors
JOIN courses ON course_instructors.course_id = courses.course_id
JOIN instructors ON course_instructors.instructor_id = instructors.instructor_id
WHERE course_instructors.semester = 'Fall 2024'; 

1----------------------------------------------------------------
DELIMITER //
CREATE FUNCTION GetStudentAge(date_of_birth DATE)
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE age INT;
SET age = TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE());
RETURN age;

END //

DELIMITER ;
2----------------------------------------------------------------


DELIMITER //

CREATE PROCEDURE EnrollStudent(
    IN student_id INT, 
    IN course_id INT
)
BEGIN
    DECLARE student_exists INT;
    DECLARE course_exists INT;
    DECLARE already_enrolled INT;
    
    SELECT COUNT(*) INTO student_exists FROM students WHERE student_id = student_id;
    
    SELECT COUNT(*) INTO course_exists FROM courses WHERE course_id = course_id;
    
    SELECT COUNT(*) INTO already_enrolled 
    FROM enrollment 
    WHERE student_id = student_id AND course_id = course_id;

    IF student_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'not found student';
    ELSEIF course_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'not found course';
    ELSEIF already_enrolled > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The student is registered in this course.!';
    ELSE
        INSERT INTO enrollment (student_id, course_id)
        VALUES (student_id, course_id);
        
        SELECT ' The student has successfully registered for the course.' AS message;
    END IF;
END //

DELIMITER ;

----------------------------------------------------------------

SELECT 
    department,
    ROUND(AVG(
        CASE 
            WHEN grade REGEXP '^[0-9]+$' THEN grade 
            ELSE NULL 
        END
    ), 2) AS average_grade
FROM enrollment 
JOIN courses ON course_id = course_id
GROUP BY department;

