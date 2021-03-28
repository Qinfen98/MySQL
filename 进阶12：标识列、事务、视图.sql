#标识列
/*
又称为自增长列
含义：可以不用手动的插入值，系统提供默认的序列值


特点：
1、标识列必须和主键搭配吗？不一定，但要求是一个key
2、一个表可以有几个标识列？至多一个！
3、标识列的类型只能是数值型 int float double都可以
4、标识列可以通过 SET auto_increment_increment=3;设置步长
可以通过 手动插入值，设置起始值


*/

#一、创建表时设置标识列

DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity(
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20),
	seat INT 

);
TRUNCATE TABLE tab_identity;


INSERT INTO tab_identity(id,NAME) VALUES(10,'john');
INSERT INTO tab_identity(NAME) VALUES('lucy');
SELECT * FROM tab_identity;


SHOW VARIABLES LIKE '%auto_increment%';

SET auto_increment_increment=3;


#二、修改表时设置标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;


#三、修改表时删除标识列

ALTER TABLE tab_identity MODIFY COLUMN id INT;





#TCL   事务控制语言
/*
Transaction Control Language 事务控制语言

事务：
一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。

案例：转账

张三丰  1000
郭襄	1000

update 表 set 张三丰的余额=500 where name='张三丰'
意外
update 表 set 郭襄的余额=1500 where name='郭襄'


事务的特性：
ACID
原子性：一个事务不可再分割，要么都执行要么都不执行
一致性：一个事务执行会使数据从一个一致状态切换到另外一个一致状态
隔离性：一个事务的执行不受其他事务的干扰
持久性：一个事务一旦提交，则会永久的改变数据库的数据.



事务的创建
隐式事务：事务没有明显的开启和结束的标记
比如insert、update、delete语句

delete from 表 where id =1;

显式事务：事务具有明显的开启和结束的标记
前提：必须先设置自动提交功能为禁用

set autocommit=0;

步骤1：开启事务
set autocommit=0;
start transaction;可选的
步骤2：编写事务中的sql语句(select insert update delete)
语句1;
语句2;
...

步骤3：结束事务
commit;提交事务
rollback;回滚事务

savepoint 节点名;设置保存点



脏读: 对于两个事务 T1, T2, T1 读取了已经被 T2 更新但还 没有被提交的字段.
之后, 若 T2 回滚, T1读取的内容就是临时且无效的.
不可重复读: 对于两个事务T1, T2, T1 读取了一个字段, 然后 T2  更新了该字段.
之后, T1再次读取同一个字段, 值就不同了.
幻读: 对于两个事务T1, T2, T1 从一个表中读取了一个字段, 然后 T2 在该表中 插
入了一些新的行. 之后, 如果 T1 再次读取同一个表, 就会多出几行.


事务的隔离级别：
		  脏读		不可重复读	幻读
read uncommitted：√		√		√
read committed：  ×		√		√
repeatable read： ×		×		√
serializable	  ×             ×               ×


mysql中默认 第三个隔离级别 repeatable read
oracle中默认第二个隔离级别 read committed
查看隔离级别
select @@tx_isolation;
设置隔离级别
set session|global transaction isolation level 隔离级别;




开启事务的语句;
update 表 set 张三丰的余额=500 where name='张三丰'

update 表 set 郭襄的余额=1500 where name='郭襄' 
结束事务的语句;



*/

SHOW ENGINES;    # 查看mysql支持的存储引擎



#1.演示事务的使用步骤
CREATE TABLE account(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	balance DOUBLE
);

INSERT INTO account(username,balance)
VALUES('张无忌',500),('赵敏',1500);

SELECT * FROM account;
DROP TABLE IF EXISTS account ;


#开启事务
SET autocommit = 0;
START TRANSACTION;

#编写一组事务的语句
UPDATE account SET balance = 1000 WHERE username = '张无忌';
UPDATE account SET balance = 1000 WHERE username='赵敏';

#结束事务
# commit;  提交事务
ROLLBACK;  # 回滚

SELECT * FROM account;


#2.演示事务对于delete和truncate的处理的区别

SET autocommit=0;
START TRANSACTION;

DELETE FROM account;
ROLLBACK;



#3.演示savepoint 的使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=25;
SAVEPOINT a;#设置保存点
DELETE FROM account WHERE id=28;
ROLLBACK TO a;#回滚到保存点


SELECT * FROM account;



#视图
/*
含义：虚拟表，和普通表一样使用
mysql5.1版本出现的新特性，是通过表动态生成的数据

比如：舞蹈班和普通班级的对比
	创建语法的关键字	是否实际占用物理空间	使用

视图	create view		只是保存了sql逻辑	增删改查，只是一般不能增删改

表	create table		保存了数据		增删改查


*/

#案例：查询姓张的学生名和专业名
SELECT stuName,majorName FROM stuinfo AS s
INNER JOIN major AS m ON s.`majorId`=m.`id`
WHERE s.`stuName` LIKE '张%';

CREATE VIEW v1
AS
SELECT stuName,majorName FROM stuinfo AS s
INNER JOIN major AS m ON s.`majorId`=m.`id`;

SELECT * FROM v1 WHERE stuName LIKE '张%';



#一、创建视图
/*
语法：
create view 视图名
as
查询语句;

*/


USE myemployees;
#1.查询姓名中包含a字符的员工名、部门名和工种信息
#①创建
CREATE VIEW myv1
AS
SELECT last_name,department_name,job_title
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
JOIN jobs AS j ON e.job_id = j.job_id;


#②使用
SELECT * FROM myv1 WHERE last_name LIKE '%a%';



/*
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  int,
 highest_sal int);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);

*/




#2.查询各部门的平均工资级别
#①创建视图查看每个部门的平均工资
CREATE VIEW myv2
AS
SELECT AVG(salary) AS ag,department_id
FROM employees AS e
GROUP BY department_id;


#②使用
SELECT myv2.ag,g.grade_level,department_id
FROM myv2
JOIN job_grades AS g
ON myv2.ag BETWEEN g.lowest_sal AND g.highest_sal;


#3.查询平均工资最低的部门信息
SELECT * FROM myv2 ORDER BY ag LIMIT 1;

#4.查询平均工资最低的部门名和工资
CREATE VIEW myv3
AS
SELECT * FROM myv2 ORDER BY ag LIMIT 1;

SELECT d.*,m.ag
FROM myv3 AS m
JOIN departments AS d ON d.`department_id` = m.department_id;



#二、视图的修改

#方式一：
/*
create or replace view  视图名
as
查询语句;

*/

CREATE OR REPLACE VIEW myv3
AS
SELECT AVG(salary),job_id
FROM employees
GROUP BY job_id;

SELECT * FROM myv3 



#方式二：
/*
语法：
alter view 视图名
as 
查询语句;

*/

ALTER VIEW myv3
AS
SELECT * FROM employees;

SELECT * FROM myv3 


#三、删除视图

/*

语法：drop view 视图名,视图名,...;
*/

DROP VIEW myv1,myv2,myv3;

#四、查看视图
DESC myv3;

SHOW CREATE VIEW myv3;



# 【案例讲解】
#一、创建视图emp_v1,要求查询电话号码以‘011’开头的员工姓名和工资、邮箱
CREATE VIEW emp_v1
AS
SELECT last_name,salary,email FROM employees
WHERE phone_number LIKE '011%';

SELECT * FROM emp_v1;


#二、创建视图emp_v2，要求查询部门的最高工资高于12000的部门信息
CREATE VIEW emp_v2
AS
SELECT MAX(e.salary),d.*
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
GROUP BY e.department_id
HAVING MAX(e.salary) > 12000;

SELECT * FROM emp_v2;




#五、视图的更新

CREATE OR REPLACE VIEW myv1
AS
SELECT last_name,email
FROM employees;


SELECT * FROM myv1;
SELECT * FROM employees;


#1.插入
INSERT INTO myv1 VALUES('张飞','zf@qq.com');


#2.修改
UPDATE myv1 SET last_name = '张无忌' WHERE last_name = '张飞';


#3.删除
DELETE FROM myv1 WHERE last_name = '张无忌';




#具备以下特点的视图不允许更新

#①包含以下关键字的sql语句：分组函数、distinct、group  by、having、union或者union all

CREATE OR REPLACE VIEW myv1
AS
SELECT MAX(salary) m,department_id
FROM employees
GROUP BY department_id;

SELECT * FROM myv1;

#更新
UPDATE myv1 SET m=9000 WHERE department_id=10;

#②常量视图
CREATE OR REPLACE VIEW myv2
AS

SELECT 'john' NAME;

SELECT * FROM myv2;

#更新
UPDATE myv2 SET NAME='lucy';





#③Select中包含子查询

CREATE OR REPLACE VIEW myv3
AS

SELECT department_id,(SELECT MAX(salary) FROM employees) 最高工资
FROM departments;

#更新
SELECT * FROM myv3;
UPDATE myv3 SET 最高工资=100000;


#④join
CREATE OR REPLACE VIEW myv4
AS

SELECT last_name,department_name
FROM employees e
JOIN departments d
ON e.department_id  = d.department_id;

#更新

SELECT * FROM myv4;
UPDATE myv4 SET last_name  = '张飞' WHERE last_name='Whalen';
INSERT INTO myv4 VALUES('陈真','xxxx');



#⑤from一个不能更新的视图
CREATE OR REPLACE VIEW myv5
AS

SELECT * FROM myv3;

#更新

SELECT * FROM myv5;

UPDATE myv5 SET 最高工资=10000 WHERE department_id=60;



#⑥where子句的子查询引用了from子句中的表

CREATE OR REPLACE VIEW myv6
AS

SELECT last_name,email,salary
FROM employees
WHERE employee_id IN(
	SELECT  manager_id
	FROM employees
	WHERE manager_id IS NOT NULL
);

#更新
SELECT * FROM myv6;
UPDATE myv6 SET salary=10000 WHERE last_name = 'k_ing';














