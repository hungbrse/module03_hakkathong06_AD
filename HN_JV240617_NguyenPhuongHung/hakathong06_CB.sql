CREATE DATABASE QUANLYDIEMTHI;
use QUANLYDIEMTHI;

CREATE TABLE subject(
subjectId VARCHAR(4) PRIMARY KEY,
subjectName VARCHAR(45),
priority int
);

CREATE TABLE student(
studentId VARCHAR(4) PRIMARY KEY,
studentName VARCHAR(100),
birthDay DATE,
gender BIT(1),
address TEXT,
phoneNumber VARCHAR(45)
);

CREATE TABLE mark(
subjectId VARCHAR(4),FOREIGN KEY(subjectId) REFERENCES subject(subjectId),
studentId VARCHAR(4),FOREIGN KEY(studentId) REFERENCES student(studentId),
point DOUBLE
);

INSERT into student(studentId,studentName,birthDay,gender,address,phoneNumber) VALUES
('S001', 'nguyen the anh' ,'1999-01-11', 1,'ha noi' ,'0984678082'),
('S002','dang bao tram','2000-05-05',0,'lao cai','904982654'),
('S003','tran ha phuong','1998-12-22',0,'nghe an','947645363'),
('S004','do tien manh','1999-03-26',1,'ha noi','983665353'),
('S007','pham duy nhat ','1998-10-04',1,'tuyen quang','987242678'),
('S005','mai van thai','2002-06-22',1,'nam dinh','982654268'),
('S006','giang gia han','1996-11-10',0,'phu tho','982364753'),
('S008','nguyen ngoc bao my','1999-01-22',0,'ha nam ','927867453'),
('S009','nguyen tien dat','1998-08-07',1,'tuyen quang','989274673'),
('S010','nguyen thieu quang','2000-09-18',1,'ha noi','984378291');



INSERT into subject(subjectId,subjectName,priority) VALUES
('MH01','toan',2),
('MH02','vat ly',2),
('MH03','hoa hoc',1),
('MH04','ngu van',1),
('MH05','anh',2);

INSERT into mark(studentId, subjectId, point) VALUES
('S001','MH01',8.5),
('S001','MH02',7),
('S001','MH03',9),
('S001','MH04',9),
('S001','MH05',5),

('S002','MH01',9),
('S002','MH02',8),
('S002','MH03',6.5),
('S002','MH04',8),
('S002','MH05',6),

('S003','MH01',7.5),
('S003','MH02',6.5),
('S003','MH03',8),
('S003','MH04',7),
('S003','MH05',7),

('S004','MH01',6),
('S004','MH02',7),
('S004','MH03',5),
('S004','MH04',6.5),
('S004','MH05',8),

('S005','MH01',5.5),
('S005','MH02',8),
('S005','MH03',7.5),
('S005','MH04',8.5),
('S005','MH05',9),

('S006','MH01',8),
('S006','MH02',10),
('S006','MH03',9),
('S006','MH04',7.5),
('S006','MH05',6.5),

('S007','MH01',9.5),
('S007','MH02',9),
('S007','MH03',6),
('S007','MH04',9),
('S007','MH05',4),

('S008','MH01',10),
('S008','MH02',8.5),
('S008','MH03',8.5),
('S008','MH04',6),
('S008','MH05',9.5),

('S009','MH01',7.5),
('S009','MH02',7),
('S009','MH03',9),
('S009','MH04',5),
('S009','MH05',10),

('S010','MH01',6.5),
('S010','MH02',8),
('S010','MH03',5.5),
('S010','MH04',4),
('S010','MH05',7);

UPDATE student SET studentName ='do duc manh' WHERE studentId = 'S004';

UPDATE subject set subjectName = 'ngoai ngu' , priority = 1  WHERE subjectId ='MH05';


UPDATE mark 
SET point = 8.5 
WHERE studentId = 'S009' AND subjectId = 'MH01';

UPDATE mark 
SET point = 7 
WHERE studentId = 'S009' AND subjectId = 'MH02';

UPDATE mark 
SET point = 5.5 
WHERE studentId = 'S009' AND subjectId = 'MH03';

UPDATE mark 
SET point = 6 
WHERE studentId = 'S009' AND subjectId = 'MH04';

UPDATE mark 
SET point = 9 
WHERE studentId = 'S009' AND subjectId = 'MH05';


DELETE FROM mark WHERE studentId ='S010';
DELETE FROM student WHERE studentId ='S010';


SELECT * FROM student;

SELECT subjectName ,subjectId FROM subject WHERE priority = 1;



SELECT studentId,studentName,year(CURDATE()) - YEAR(birthDay) as tuoi ,
case 
 when gender = 1 then 'nam'
 else 'nu'
 end as gioi_tinh,
 address 
 from student;
 
 
 SELECT student.studentName , subject.subjectName , mark.point FROM student JOIN mark on student.studentId = mark.studentId
 JOIN subject on mark.subjectId = subject.subjectId WHERE subject.subjectName ='toan'  ORDER BY mark.point DESC;
 
 
 SELECT 
    CASE 
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS gioi_tinh,
    COUNT(*) AS so_luong
FROM student
GROUP BY gender;

 

SELECT
student.studentId , student.studentName , sum(mark.point) as tong_diem , avg(mark.point) as trung_binh
FROM student JOIN mark on student.studentId = mark.studentId GROUP BY student.studentId;

CREATE VIEW STUDENT_VIEW AS
SELECT 
    studentId, 
    studentName,
    CASE 
        WHEN gender = 1 THEN 'nam'
        ELSE 'nu'
    END AS gender,
    address 
FROM student;

CREATE VIEW AVERAGE_MARK_VIEW as
SELECT student.studentId ,student.studentName ,avg(mark.point) as trung_binh 
FROM student JOIN mark on  mark.studentId = student.studentId 
GROUP BY
student.studentId;

CREATE INDEX index_phone on student(studentName);


DELIMITER //
CREATE PROCEDURE addStudent(
in id VARCHAR(4),
in name VARCHAR(100),
in birthDay DATE,
in gender BIT(1),
in address TEXT,
in phoneNumber VARCHAR(45))
BEGIN
INSERT into student(studentId,studentName,birthDay,gender,address,phoneNumber) VALUES
(id,name,birthDay,gender,address,phoneNumber);
END //
DELIMITER ;

CALL addStudent('S011' ,'hung thieu gia','2001-12-28',1,'tien trong',0974356313);

DELIMITER //
CREATE PROCEDURE PROC_UPDATESUBJECT(
in id VARCHAR(4),
in newSubjectName VARCHAR(45) )
BEGIN
UPDATE subject set subjectName = newSubjectName WHERE subjectId =  id;
END //
DELIMITER ;

CALL PROC_UPDATESUBJECT('MH03','fbi warning');

DELIMITER //
CREATE PROCEDURE PROC_DELETEMARK(
    IN id VARCHAR(4)
)
BEGIN
    DELETE FROM mark
    WHERE studentId = id;
END //
DELIMITER ;
