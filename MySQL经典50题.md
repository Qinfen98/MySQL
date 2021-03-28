/*
创建表

--1.学生表
Student(SID,Sname,Sage,Ssex) --SID 学生编号,Sname 学生姓名,Sage 出生年月,Ssex 学生性别
--2.课程表
Course(CID,Cname,TID) --CID --课程编号,Cname 课程名称,TID 教师编号
--3.教师表
Teacher(TID,Tname) --TID 教师编号,Tname 教师姓名
--4.成绩表
SC(SID,CID,score) --SID 学生编号,CID 课程编号,score 分数
*/

```
ALTER DATABASE students CHARACTER SET utf8;

CREATE TABLE student 
(SID VARCHAR(10),Sname VARCHAR(20),Sage DATETIME,Ssex VARCHAR(10));

插入数据

INSERT INTO Student VALUES('01' , '赵雷' , '1990-01-01' , '男');
INSERT INTO Student VALUES('02' , '钱电' , '1990-12-21' , '男');
INSERT INTO Student VALUES('03' , '孙风' , '1990-05-20' , '男');
INSERT INTO Student VALUES('04' , '李云' , '1990-08-06' , '男');
INSERT INTO Student VALUES('05' , '周梅' , '1991-12-01' , '女');
INSERT INTO Student VALUES('06' , '吴兰' , '1992-03-01' , '女');
INSERT INTO Student VALUES('07' , '郑竹' , '1989-07-01' , '女');
INSERT INTO Student VALUES('08' , '王菊' , '1990-01-20' , '女');


CREATE TABLE Course(CID VARCHAR(10),Cname VARCHAR(10),TID VARCHAR(10));
INSERT INTO Course VALUES('01' , '语文' , '02');
INSERT INTO Course VALUES('02' , '数学' , '01');
INSERT INTO Course VALUES('03' , '英语' , '03');

CREATE TABLE Teacher(TID VARCHAR(10),Tname VARCHAR(10));
INSERT INTO Teacher VALUES('01' , '张三');
INSERT INTO Teacher VALUES('02' , '李四');
INSERT INTO Teacher VALUES('03' , '王五');
```



```
CREATE TABLE SC(SID VARCHAR(10),CID VARCHAR(10),score DECIMAL(18,1));
INSERT INTO SC VALUES('01' , '01' , 80);
INSERT INTO SC VALUES('01' , '02' , 90);
INSERT INTO SC VALUES('01' , '03' , 99);
INSERT INTO SC VALUES('02' , '01' , 70);
INSERT INTO SC VALUES('02' , '02' , 60);
INSERT INTO SC VALUES('02' , '03' , 80);
INSERT INTO SC VALUES('03' , '01' , 80);
INSERT INTO SC VALUES('03' , '02' , 80);
INSERT INTO SC VALUES('03' , '03' , 80);
INSERT INTO SC VALUES('04' , '01' , 50);
INSERT INTO SC VALUES('04' , '02' , 30);
INSERT INTO SC VALUES('04' , '03' , 20);
INSERT INTO SC VALUES('05' , '01' , 76);
INSERT INTO SC VALUES('05' , '02' , 87);
INSERT INTO SC VALUES('06' , '01' , 31);
INSERT INTO SC VALUES('06' , '03' , 34);
INSERT INTO SC VALUES('07' , '02' , 89);
INSERT INTO SC VALUES('07' , '03' , 98);
```

建表完成

![image-20210305183618642](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210305183618642.png)

![image-20210305183629166](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210305183629166.png)

![image-20210305183950929](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210305183950929.png)

![image-20210305183656462](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210305183656462.png)



#--1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数

```
SELECT s.*,a.`score` AS score01,b.`score` AS score02
FROM student AS s
JOIN SC AS a ON  s.`SID`=a.`SID` AND a.`CID`="01"
LEFT JOIN SC AS b ON  s.`SID`=b.`SID` AND b.`CID`="02"
OR b.`CID` = NULL 
WHERE a.`score`>b.`score`;
```

![image-20210306090142909](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306090142909.png)

#--2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数（同上题）

```
SELECT s.*,a.`score` AS score01,b.`score` AS score02
FROM student AS s
JOIN SC AS a ON  s.`SID`=a.`SID` AND a.`CID`="01"
LEFT JOIN SC AS b ON  s.`SID`=b.`SID` AND b.`CID`="02"
OR b.`CID` = NULL 
WHERE a.`score`<b.`score`;
```

![image-20210306090226068](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306090226068.png)





3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

```
SELECT s.SID,s.Sname,AVG(a.score) AS avg_score
FROM student AS s
JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY a.`SID`
HAVING avg_score >= 60;
```

![image-20210306091157154](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306091157154.png)

4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩

```
SELECT s.SID,s.Sname,AVG(a.score) AS avg_score
FROM student AS s
JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY a.`SID`
HAVING avg_score < 60;
```

![image-20210306091356835](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306091356835.png)



5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩

```
#【这里一定要用外连接，因为有的同学没有选课，不然用内连接筛选不出来】

SELECT s.`SID`,s.`Sname`,COUNT(a.`CID`) AS 选课总数,SUM(a.`score`) AS 总成绩
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY a.`SID`,s.`Sname`;
```

![image-20210306093517583](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306093517583.png)



#--6、查询"李"姓老师的数量

```
SELECT COUNT(*)
FROM teacher
WHERE Tname LIKE '李%';
```

![image-20210306093743452](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306093743452.png)



#7、查询学过"张三"老师授课的同学的信息

```
#方法一：
SELECT s.*
FROM student AS s
JOIN SC AS a ON s.`SID`=a.`SID`
JOIN course AS c ON c.`CID`=a.`CID`
JOIN teacher AS t ON t.`TID`=c.`TID`
WHERE t.`Tname` = '张三';

# 方法二：
SELECT s.*
FROM student AS s
JOIN SC AS a ON s.`SID`=a.`SID`
WHERE a.`CID` IN(
	SELECT CID FROM course AS c
		WHERE TID=(
			SELECT TID FROM teacher AS t 
				WHERE t.`Tname`='张三')	
);

```

![image-20210306094236802](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306094236802.png)

--【*******】8、查询没学过"张三"老师授课的同学的信息

```
SELECT s.*
FROM student AS s
WHERE s.`SID` NOT IN (
	SELECT a.`SID` FROM student AS a JOIN SC AS b ON a.`SID`=b.`SID`
		WHERE b.`CID` IN (
			SELECT c.`CID`  FROM course AS c JOIN teacher AS t ON c.`TID`=t.`TID`
				WHERE t.`Tname`='张三')
);
```

![image-20210306103439274](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306103439274.png)



#--9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息

```mysql
SELECT s.*,a.`CID`,b.`CID`
FROM student AS s,SC AS a,SC AS b
WHERE s.`SID`=a.`SID`
AND s.`SID`=b.`SID`
AND a.`CID`='01' 
AND b.`CID`='02';
```

![image-20210306104258264](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306104258264.png)



#--10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息

```
SELECT s.*
FROM student AS s
WHERE s.`SID` IN (
	SELECT SID FROM SC WHERE CID='01'
)
AND s.`SID` NOT IN(
	SELECT SID FROM SC WHERE CID='02'
);
```



![image-20210306110633952](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306110633952.png)





#--11、查询没有学全所有课程的同学的信息

```
SELECT s.*
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY s.`SID`
HAVING COUNT(s.`SID`)< (SELECT COUNT(*) FROM course);
```

![image-20210306111310237](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306111310237.png)



--12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息

```
方法一：

SELECT DISTINCT s.*
FROM student AS s
JOIN SC AS a ON s.`SID`=a.`SID`
WHERE a.`CID` IN (
	SELECT CID
	FROM student AS s
	JOIN SC AS a ON s.`SID`=a.`SID`
	WHERE s.`SID`='01'
);

方法二：

SELECT * FROM student 
WHERE SID IN(
	SELECT DISTINCT a.SID FROM SC a
                  WHERE a.CID IN(SELECT a.CID FROM SC a WHERE a.SID='01')
	);
		
```

![image-20210306112118538](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306112118538.png)

--13、查询和"01"号的同学学习的课程完全相同的其他同学的信息

```
select s.*
from student as s
join SC as a on s.`SID`=a.`SID`
group by a.`SID`
having group_concat(a.`CID`) = (
	select group_concat(CID)
	from SC
	group by SID
	Having SID = '01')
and a.`SID` != '01';
```

#--14、查询没学过"张三"老师讲授的任一门课程的学生姓名

```
SELECT  s.`Sname`
FROM student AS s
WHERE s.`SID` NOT IN (
	SELECT SID FROM SC AS a
	WHERE CID = (
		SELECT CID FROM course AS c
		JOIN teacher AS t ON c.`TID`=t.`TID`
		WHERE t.`Tname`='张三')	
);
```

![image-20210306121139846](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306121139846.png)

#--15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩

```
SELECT s.`SID`,s.`Sname`,AVG(a.`score`) AS 平均成绩
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
WHERE s.`SID` IN (
	SELECT SID FROM SC WHERE score<60 
	GROUP BY SID 
	HAVING COUNT(*)>=2
)
GROUP BY s.`SID`,s.`Sname`;
```

![image-20210306131652960](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306131652960.png)



#--16、检索"01"课程分数小于60，按分数降序排列的学生信息
```
# 方法一：

SELECT s.*,a.`score`
FROM student AS s,SC AS a
WHERE s.`SID`=a.`SID`
AND a.`CID`='01'
AND a.`score`<60
ORDER BY score DESC;


# 方法二：

SELECT s.*,a.`score`
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
WHERE a.`CID`='01'
AND a.`score`<60
ORDER BY score DESC;
```



![image-20210306132424376](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306132424376.png)





--17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩

```
SELECT s.`SID`,s.`Sname`,
	SUM(CASE WHEN a.`CID`='01'THEN IFNULL(a.`score`,0)ELSE 0 END) AS '语文',
	SUM(CASE WHEN a.`CID`='02'THEN IFNULL(a.`score`,0)ELSE 0 END) AS '数学',
	SUM(CASE WHEN a.`CID`='02'THEN IFNULL(a.`score`,0)ELSE 0 END) AS '英语',
	ROUND(AVG(a.`score`),2) AS 平均成绩
FROM SC AS a
LEFT JOIN student AS s ON a.`SID`=s.`SID`
GROUP BY a.`SID`
UNION
SELECT s1.SID,s1.Sname,0 AS '语文',0 AS '数学',0 AS '英语',0 AS '平均成绩'
FROM student AS s1
WHERE s1.SID NOT IN (SELECT DISTINCT SID FROM SC)
ORDER BY 平均成绩 DESC;

```

![image-20210316110350061](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316110350061.png)

#--18、查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率

及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

[典型题目]

```
SELECT a.`CID`,b.`Cname`,MAX(a.`score`) AS 最高分,MIN(a.`score`) AS 最低分,AVG(a.`score`) AS 平均分,
	ROUND(100*(SUM(CASE WHEN a.`score`>=60 THEN 1 ELSE 0 END)/SUM(CASE WHEN a.`score` THEN 1 ELSE 0 END)),2) AS 及格率,
	ROUND(100*(SUM(CASE WHEN a.`score`>=70 AND a.`score`<80  THEN 1 ELSE 0 END)/SUM(CASE WHEN a.`score` THEN 1 ELSE 0 END)),2) AS 中等率,
	ROUND(100*(SUM(CASE WHEN a.`score`>=80 AND a.`score`<90  THEN 1 ELSE 0 END)/SUM(CASE WHEN a.`score` THEN 1 ELSE 0 END)),2) AS 优良率,
	ROUND(100*(SUM(CASE WHEN a.`score`>=90 THEN 1 ELSE 0 END)/SUM(CASE WHEN a.`score` THEN 1 ELSE 0 END)),2) AS 优秀率	
FROM SC AS a 
LEFT JOIN course AS b ON a.`CID`=b.`CID`
GROUP BY a.`CID`,b.`Cname`;
```

![image-20210306143620291](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210306143620291.png)



--19、按各科成绩进行排序，并显示排名

#(我觉得这个题使用开窗函数蛮好的，但我用的mysql5.5不支持开窗函数，我就不用这个方法了)

```
SELECT a.* ,  (SELECT COUNT(DISTINCT score) FROM SC WHERE CID = a.CID AND score >a.score) +1 AS 排名 FROM SC AS a ORDER BY a.cid , 排名;
```

![image-20210315142831655](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315142831655.png)

--20、查询学生的总成绩并进行排名（没做完）

```
SELECT s.`SID`,s.`Sname`,SUM(a.`score`) AS 总成绩
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY s.`SID`,s.`Sname`
ORDER BY 总成绩;
```

![image-20210315144857109](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315144857109.png)

--21、查询不同老师所教不同课程平均分从高到低显示 

```
SELECT t.`TID`,t.`Tname`,ROUND(AVG(a.`score`),2) AS 平均分,c.`CID`
FROM course AS c
LEFT JOIN teacher AS t ON t.`TID`=c.`TID`
LEFT JOIN SC AS a ON a.`CID`=c.`CID`
GROUP BY t.`TID`
ORDER BY 平均分 DESC;
```

![image-20210315150423617](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315150423617.png)

--22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩

```
SELECT a.* , (SELECT COUNT(DISTINCT score) FROM SC WHERE CID = a.CID AND score > a.score) + 1 AS 排名
FROM SC AS a HAVING 排名 BETWEEN 2 AND 3 ORDER BY a.CID,排名;
```

![image-20210315152613511](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315152613511.png)

--23、统计各科成绩各分数段人数：课程编号,课程名称, 100-85 , 85-70 , 70-60 , 0-60 及所占百分比 

```
SELECT DISTINCT f.Cname,a.CID,b.`85-100`,b.百分比,c.`70-85`,c.百分比,d.`60-70`,d.百分比,e.`0-60`,e.百分比 FROM SC AS a
LEFT JOIN (SELECT CID,SUM(CASE WHEN score >85 AND score <=100 THEN 1 ELSE 0 END) AS `85-100`,ROUND(100*(SUM(CASE WHEN score >85 AND score <=100 THEN 1 ELSE 0 END)/COUNT(*)),2) AS 百分比 FROM SC GROUP BY CID) AS b ON a.CID=b.CID
LEFT JOIN (SELECT CID,SUM(CASE WHEN score >70 AND score <=85 THEN 1 ELSE 0 END) AS `70-85`,ROUND(100*(SUM(CASE WHEN score >70 AND score <=85 THEN 1 ELSE 0 END)/COUNT(*)),2) AS 百分比 FROM SC GROUP BY CID) AS c ON a.CID=c.CID
LEFT JOIN (SELECT CID,SUM(CASE WHEN score >60 AND score <=70 THEN 1 ELSE 0 END) AS `60-70`,ROUND(100*(SUM(CASE WHEN score >60 AND score <=70 THEN 1 ELSE 0 END)/COUNT(*)),2) AS 百分比 FROM SC GROUP BY CID) AS d ON a.CID=d.CID
LEFT JOIN (SELECT CID,SUM(CASE WHEN score >=0 AND score <=60 THEN 1 ELSE 0 END) AS `0-60`,ROUND(100*(SUM(CASE WHEN score >=0 AND score <=60 THEN 1 ELSE 0 END)/COUNT(*)),2) AS 百分比 FROM SC GROUP BY CID)e ON a.CID=e.CID
LEFT JOIN course AS f ON a.CID = f.CID;
```

![image-20210315164831141](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315164831141.png)

--24、查询学生平均成绩及其名次

```
SELECT t1.*,(SELECT COUNT(1) FROM (
	SELECT  s.SID,s.Sname,AVG(a.score) AS 平均成绩
	FROM student AS s
	LEFT JOIN SC AS a ON s.SID = a.SID
	GROUP BY s.SID,s.Sname) AS t2
	WHERE 平均成绩>t1.平均成绩)+1 AS 排名	
FROM
(	SELECT  s.SID,s.Sname,AVG(a.score) AS 平均成绩
	FROM student AS s
	LEFT JOIN SC AS a ON s.SID = a.SID
	GROUP BY s.SID,s.Sname) AS t1
ORDER BY 排名;
```

![image-20210315192928186](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315192928186.png)

--25、查询各科成绩前三名的记录

```
SELECT a.`SID`,a.`CID`,a.`score`,COUNT(b.score) +1 AS 排名
FROM SC AS a
LEFT JOIN SC AS b ON a.`CID`=b.`CID` AND a.`score`<b.`score`
GROUP BY a.`SID`,a.`CID`,a.`score`
HAVING COUNT(b.`SID`)<3
ORDER BY a.`CID`,排名 ;
```

<img src="C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315200800107.png" alt="image-20210315200800107" style="zoom:50%;" />

--26、查询每门课程被选修的学生数

```
SELECT a.`CID`,COUNT(a.`SID`)
FROM SC AS a 
GROUP BY a.`CID`;
```

<img src="C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315202425712.png" alt="image-20210315202425712" style="zoom:50%;" />

--27、查询出只有两门课程的全部学生的学号和姓名

```
SELECT s.`SID`,s.`Sname`
FROM student AS s
JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY s.`SID`,s.`Sname`
HAVING COUNT(a.`CID`)=2;
```

![image-20210315202912237](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315202912237.png)



#--28、查询男生、女生人数

```
SELECT s.`Ssex`,COUNT(s.`Ssex`) AS 人数
FROM student AS s
GROUP BY s.`Ssex`;
```

![image-20210315203408377](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315203408377.png)

--29、查询名字中含有"风"字的学生信息

```
select s.*
from student as s
where s.`Sname` like '%风%';
```

![image-20210315203530560](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315203530560.png)



#--30、查询同名同性学生名单，并统计同名人数

```
SELECT a.`Sname`,a.`Ssex`
FROM student AS a
JOIN student AS b ON a.`SID`=b.`SID` AND a.`Sname`=b.`Sname` AND a.`Ssex`=b.`Ssex`
GROUP BY a.`SID`,a.`Sname`
HAVING COUNT(*)>1;
# 没有同名同性的人
```

--31、查询1990年出生的学生名单(注：Student表中Sage列的类型是datetime)

```
SELECT s.*
FROM student AS s
WHERE s.`Sage` LIKE '1990%';
```

![image-20210315204203441](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315204203441.png)



--32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列

```
SELECT a.`CID`,ROUND(AVG(a.`score`),2) AS 平均成绩
FROM SC AS a
GROUP BY a.`CID`
ORDER BY 平均成绩 DESC,a.`CID` ASC;
```

![image-20210315204659669](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315204659669.png)

--33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩

```
SELECT s.`SID`,s.`Sname`,ROUND(AVG(a.`score`),2) AS 平均成绩
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
GROUP BY s.`SID`,s.`Sname`
HAVING 平均成绩 >= 85;
```

![image-20210315205102081](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315205102081.png)

#--34、查询课程名称为"数学"，且分数低于60的学生姓名和分数

```
SELECT s.`Sname`,a.`score`
FROM SC AS a
LEFT JOIN student AS s ON a.`SID`=s.`SID`
LEFT JOIN course AS c ON a.`CID`=c.`CID`
WHERE c.`Cname`='数学'
AND a.`score`<60;
```

![image-20210315205424912](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315205424912.png)

--35、查询所有学生的课程及分数情况；

```
SELECT s.*,a.`CID`,c.`Cname`,a.`score`
FROM student AS s,SC AS a,course AS c
WHERE s.`SID`=a.`SID` AND a.`CID`=c.`CID`
GROUP BY s.`SID`,a.`CID`
ORDER BY s.`SID`,a.`CID`;
```

#--36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数；

```
SELECT s.`Sname`,a.`score`,c.`Cname`
FROM SC AS a
LEFT JOIN student AS s ON a.`SID`=s.`SID`
LEFT JOIN course AS c ON a.`CID`=c.`CID`
WHERE a.`score`>70
GROUP BY s.`SID`,a.`CID`;
```

<img src="C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315210506528.png" alt="image-20210315210506528" style="zoom:33%;" />

--37、查询不及格的课程

```
SELECT s.*,a.`CID`,c.`Cname`,a.`score`
FROM SC AS a
JOIN course AS c ON a.`CID`=c.`CID`
JOIN student AS s ON a.`SID`=s.`SID`
WHERE a.`score`<60;
```

![image-20210315210812787](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315210812787.png)

#--38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名；

```
SELECT s.`SID`,s.`Sname`,a.`CID`,a.`score`
FROM student AS s
LEFT JOIN SC AS a ON s.`SID`=a.`SID`
WHERE a.`CID`=01
AND a.`score`>=80;
```

![image-20210315211040622](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315211040622.png)



--39、求每门课程的学生人数

```
select a.`CID`,count(a.`CID`)as 学生人数
from SC as a
group by a.`CID`;
```

![image-20210315211325097](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315211325097.png)

--40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩

```
select s.*,a.`CID`,a.`score`,t.`Tname`
from student as s
join SC as a on a.`SID`=s.`SID`
join course as c on c.`CID`=a.`CID`
join teacher as t on t.`TID`=c.`TID`
where t.`Tname`='张三'
and a.`score` in (
	select max(score) from  SC AS a 
	JOIN course AS c ON c.`CID`=a.`CID`
	JOIN teacher AS t ON t.`TID`=c.`TID`
	where t.`Tname`='张三'
);
```

![image-20210315212432917](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315212432917.png)



#--41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩

```
SELECT a.*
FROM SC AS a,(
	SELECT CID,score 
	FROM SC
	GROUP BY CID ,score
	HAVING COUNT(1)>1
) AS b
WHERE a.`CID`=b.CID
AND a.`score`=b.score
ORDER BY a.`CID`,a.`SID`,a.`score`;
```

![image-20210315214149955](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210315214149955.png)

#--42、查询每门功课成绩最好的前两名

```
SELECT a.`CID`,a.`SID`,a.`score`
FROM SC AS a
WHERE (
	SELECT COUNT(1) FROM SC AS b 
	WHERE b.`CID`=a.`CID`
	AND b.`score`>=a.`score`
) <= 2
ORDER BY a.`CID`;
```

![image-20210316090327850](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316090327850.png)

--43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列 

```
SELECT a.`CID`,COUNT(*) AS 选修人数
FROM SC AS a
GROUP BY a.`CID`
HAVING COUNT(*)>5
ORDER BY 选修人数 DESC,a.`CID` ASC;
```

![image-20210316090312960](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316090312960.png)

--44、检索至少选修两门课程的学生学号

```
SELECT a.`SID`,COUNT(*) AS 选修课程数
FROM SC AS a
GROUP BY a.`SID`
HAVING COUNT(*)>=2;
```

![image-20210316090625224](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316090625224.png)

# --45、查询选修了全部课程的学生信息

```
SELECT s.*,COUNT(*) AS 选修课程数
FROM student AS s,SC AS a
WHERE s.`SID`=a.`SID`
GROUP BY a.`SID`
HAVING COUNT(*)>=3;

SELECT *
FROM student 
WHERE SID IN (
	SELECT SID FROM SC 
	GROUP BY SID
	HAVING COUNT(*)=(SELECT COUNT(*) FROM course)
);
```

![image-20210316091327057](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316091327057.png)



--46、查询各学生的年龄

```
#1.只按年份来算
SELECT SID,Sname,YEAR(NOW())-YEAR(Sage) AS 年龄
FROM student AS s；
#2.按出生日期来算，过了生日那一天肯定就是大一岁了
SELECT SID,Sname,Sage,(DATE_FORMAT(NOW(),'%Y')-DATE_FORMAT(Sage,'%Y')-
	(CASE
	WHEN DATE_FORMAT(NOW(),'%m%d')>DATE_FORMAT(Sage,'%m%d')
	THEN 0
	ELSE 1
	END)) AS 年龄
FROM student;
```

![image-20210316093250833](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316093250833.png)



--47、查询本周过生日的学生

```
SELECT *
FROM student
WHERE WEEK(DATE_FORMAT(NOW(),'%Y%m%d'))=WEEK(Sage);
```

--48、查询下周过生日的学生

```
SELECT *
FROM student
WHERE WEEK(DATE_FORMAT(NOW(),'%Y%m%d'))+1=WEEK(Sage);


```

--49、查询本月过生日的学生

```
SELECT *
FROM student
WHERE MONTH(DATE_FORMAT(NOW(),'%Y%m%d'))=MONTH(Sage);
```

![image-20210316094418057](C:\Users\Rachel\AppData\Roaming\Typora\typora-user-images\image-20210316094418057.png)



--50、查询下月过生日的学生

```
SELECT *
FROM student
WHERE MONTH(DATE_FORMAT(NOW(),'%Y%m%d'))+1=MONTH(Sage);
```

