drop database IF EXISTS lab1;
create database lab1;
use lab1;

DROP TABLE IF EXISTS Borrow;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Reader;

CREATE TABLE Book (
  ID char(8) primary key,
  name varchar(10) NOT NULL,
  author varchar(10),
  price float,
  status int DEFAULT 0,
  check(status >= 0 and status <= 1) 
) ;

INSERT INTO Book VALUES('EN001','H.Potter','Rowling',50.80,0);
INSERT INTO Book VALUES('CN001','十宗罪','蜘蛛',35.80,0);
INSERT INTO Book(ID,name,author,price) VALUES('MT001','数学分析','常庚哲',36.10);
INSERT INTO Book VALUES('FL001','达芬奇密码','Dan Brown',35.80,0);
INSERT INTO Book VALUES('BU001','U.Digest1','Ullman',32.50,0);  /* Ullman写的书 */
INSERT INTO Book VALUES('BU002','U.Digest2','Ullman',10.08,0);  /* Ullman写的书 */
INSERT INTO Book VALUES('CT001','OracleTec','Patt',45.00,0);
INSERT INTO Book VALUES('CT002','TecOracle','Yale',68.90,0);
INSERT INTO Book VALUES('EN223','ManUTD','Forguson',1999.5,0);

CREATE TABLE Reader (
  ID char(8) NOT NULL,
  name varchar(10) NOT NULL,
  age int,
  address varchar(20),
  PRIMARY KEY (ID)
) ;

INSERT INTO Reader VALUES('PB001','Jim',18,'Apartment1');
INSERT INTO Reader VALUES('PB002','Sherlock',20,'221B');      /* 没有借任何书 */
INSERT INTO Reader VALUES('PB003','Sean',19,'Apartment2');  
INSERT INTO Reader VALUES('PB004','Rose',22,'Apartment3');
INSERT INTO Reader VALUES('PB005','李林',21,'Apartment1');
INSERT INTO Reader VALUES('PB006','Bruno',25,'Manchester');

CREATE TABLE Borrow (
  Book_ID char(8) NOT NULL,
  Reader_ID char(8) NOT NULL,
  Borrow_Date date,
  Return_Date date NULL,
  PRIMARY KEY (Book_ID,Reader_ID),
  foreign key BID_FK(Book_ID) references Book(ID),
  foreign key RID(Reader_ID) references Reader(ID),
  CHECK(Return_Date >= Borrow_Date || Return_Date is null)
) ;

INSERT INTO Borrow VALUES('EN001','PB001','2020-01-01','2020-03-01');
INSERT INTO Borrow VALUES('FL001','PB001','2020-01-01','2020-02-01');
INSERT INTO Borrow VALUES('CN001','PB001','2020-01-01','2020-02-10');
INSERT INTO Borrow(Book_ID,Reader_ID,Borrow_Date) VALUES('MT001','PB001','2020-02-11');
INSERT INTO Borrow VALUES('FL001','PB004','2020-02-02','2020-02-20');
INSERT INTO Borrow(Book_ID,Reader_ID,Borrow_Date) VALUES('CN001','PB004','2020-02-12');
INSERT INTO Borrow VALUES('CN001','PB003','2019-12-01','2019-12-12');
INSERT INTO Borrow VALUES('MT001','PB003','2019-12-01','2019-12-12');
INSERT INTO Borrow VALUES('BU001','PB005','2020-01-30','2020-03-01');  --李林借书
INSERT INTO Borrow(Book_ID,Reader_ID,Borrow_Date) VALUES('BU002','PB005','2020-01-02');  --李林借书
INSERT INTO Borrow(Book_ID,Reader_ID,Borrow_Date) VALUES('CT001','PB005','2020-01-02');  --李林借书
INSERT INTO Borrow VALUES('FL001','PB005','2020-01-01','2020-02-01');  --李林借书
INSERT INTO Borrow VALUES('EN001','PB003','2015-02-20','2017-11-11');  --大于一年前的借书记录

--2.(1)用插入时主码为空验证实体完整性：
INSERT INTO Book(name,author,price,status) VALUES('Novel','Susan',20.08,0);

--2.(2)验证参照完整性
INSERT INTO Borrow VALUES('JN001','SA001','2020-01-02','2020-03-02');
--通过向Borrow表中插入Reader和Book中没有的ID报错a foreign key constraint fails来验证参照完整性

--2.(3)验证用户定义完整性
INSERT INTO Book VALUES('B001','Book1','Kean',15.06,2);
--由于在定义status时check 0 <= status <= 1，这里输入2就会报错book_chk_1 is violated 因此满足用户定义完整性

--3.(1)检索读者 Rose 的读者号和地址；
SELECT ID,ADDRESS FROM Reader WHERE(NAME = 'Rose');

--3.(2)检索读者 Rose所借阅读书（包括已还和未还图书）的图书名和借期；
SELECT Book.name,Borrow.Borrow_Date FROM Book,Borrow,Reader WHERE(Book.ID = Borrow.Book_ID 
AND Reader.ID = Borrow.Reader_ID AND Reader.name = 'Rose');

--3.(3)检索未借阅图书的读者姓名；
SELECT Reader.name FROM Reader WHERE(Reader.name NOT IN 
(SELECT Reader.name FROM Reader,Borrow WHERE(Reader.ID = Borrow.Reader_ID)));

--3.(4)检索 Ullman所写的书的书名和单价；
SELECT Book.name,Book.price FROM Book WHERE(Book.author = 'Ullman');

--3.(5)检索读者 “李林 ”借阅未还的图书的图书号和书名；
SELECT Book.ID,BOOK.name FROM Book,Reader,Borrow 
WHERE(Reader.name = '李林' AND Borrow.Return_Date is null 
AND Book.ID = Borrow.Book_ID AND Reader.ID = Borrow.Reader_ID);

--3.(6)检索借阅图书数目超过3本的读者姓名；
SELECT Reader.name FROM Reader,Borrow    --这里默认同一个人不会借同一本书
WHERE(Reader.ID = Borrow.Reader_ID )
GROUP BY Reader.name
HAVING COUNT(*)>3;

--3.(7)检索没有借阅读者 “李林 ”所借的任何一本书的读者姓名和读者号；
SELECT DISTINCT Reader.name,Reader.ID FROM Reader,Borrow    --借书不重复与没借过书做union
WHERE Reader.ID = Borrow.Reader_ID 
AND Borrow.Reader_ID NOT IN 
(SELECT Borrow.Reader_ID FROM Borrow 
WHERE Borrow.Book_ID IN 
(SELECT Borrow.Book_ID FROM Reader,Borrow
WHERE Reader.name = '李林' AND Reader.ID = Borrow.Reader_ID))
UNION
SELECT Reader.name,Reader.ID FROM Reader WHERE(Reader.name NOT IN 
(SELECT Reader.name FROM Reader,Borrow WHERE(Reader.ID = Borrow.Reader_ID)));

--3.(8).检索书名中包含 “Oracle”的图书书名及图书号；
SELECT name,ID FROM Book
WHERE name LIKE '%Oracle%';

--3.(9)创建一个读者借书信息的视图，该视图包含读者号、姓名、所借图书号、图书名
--     和借期； 并使用该视图查询最近一年所有读者的读者号以及所借阅的不同图书数
CREATE VIEW Reader_Borrow(Reader_ID,Reader_name,Book_ID,Book_name,Borrow_Date)
AS SELECT Reader.ID,Reader.name,Borrow.Book_ID,Book.name,Borrow.Borrow_Date
FROM Book,Reader,Borrow 
WHERE(Book.ID = Borrow.Book_ID AND Reader.ID = Borrow.Reader_ID);
SELECT Reader_ID,COUNT(Book_ID) AS Book_NUM FROM Reader_Borrow
WHERE(Borrow_Date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY Reader_ID;

#4.设计 一个 存储过程，实现对Book表的ID的修改
DELIMITER $$
CREATE PROCEDURE ModifyBookID(IN NewID CHAR(8), IN OldID CHAR(8))  
BEGIN
   DECLARE s INT DEFAULT 0;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET s = 1;
	SET FOREIGN_KEY_CHECKS = 0;
   UPDATE Borrow SET Book_ID = NewID
   WHERE Book_ID = OldID;
   UPDATE Book SET ID = NewID
   WHERE ID = OldID;
   SET FOREIGN_KEY_CHECKS = 1;
END $$
CALL ModifyBookID('EN002','EN001'); 
SELECT ID FROM Book WHERE NAME='H.Potter';

--5.设计一个存储过程，检查每本图书status是否正确，并返回 status不正确的图书数
DELIMITER $$
CREATE PROCEDURE CheckWrongStatus(OUT Count INT)
BEGIN
	SELECT COUNT(ID) FROM (
    SELECT DISTINCT Book.ID FROM Book,Borrow
    WHERE Book.ID = Borrow.Book_ID 
		AND ISNULL(Borrow.Return_Date) 
		AND Book.status = 0
    UNION
    SELECT InLibrary.ID
    FROM (SELECT * FROM Book WHERE Book.status = 1)InLibrary
    WHERE NOT EXISTS(SELECT * FROM Borrow 
    WHERE InLibrary.ID = Borrow.Book_ID 
		AND InLibrary.status = 1 
        AND ISNULL(Borrow.Return_Date)))as Wrong
	INTO Count;
    SELECT Count;
END $$
CALL CheckWrongStatus(@out);
SELECT out;

--6.设计触发器，实现：当一本书被借出时，自动将 Book表中相应图书的 status修改为
--  1；当某本书被归还时，自动将status改为0
DELIMITER $$
CREATE TRIGGER UpdateBorrowStatus AFTER INSERT ON Borrow FOR EACH ROW
BEGIN
	IF ISNULL(NEW.Return_Date) THEN
		UPDATE Book SET status = 1
        WHERE Book.ID = NEW.Book_ID;
	ELSE 
		UPDATE Book SET status = 0
        WHERE Book.ID = NEW.Book_ID;
	END IF;
END;$$
DELIMITER $$
CREATE TRIGGER UpdateReturnStatus AFTER UPDATE ON Borrow FOR EACH ROW
BEGIN
	IF ISNULL(NEW.Return_Date) THEN
		UPDATE Book SET status = 1
        WHERE Book.ID = NEW.Book_ID;
	ELSE 
		UPDATE Book SET status = 0
        WHERE Book.ID = NEW.Book_ID;
	END IF;
END; $$
INSERT INTO Borrow(Book_ID,Reader_ID,Borrow_DATE) VALUES('EN223','PB006','2020-04-01');
SELECT status FROM Book WHERE ID='EN223';
UPDATE Borrow SET Return_Date='2020-04-03' WHERE(Book_ID='EN223' AND Reader_ID='PB006');
SELECT status FROM Book WHERE ID='EN223';


