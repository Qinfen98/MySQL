SHOW DATABASES;
USE test;
SHOW TABLES;
DESC labs;
USE myemployees;

/*进阶1：基础查询
	语法：
	SELECT 要查询的东西
	【FROM 表名】;

	①通过select查询完的结果 ，是一个虚拟的表格，不是真实存在
	② 要查询的东西 可以是常量值、可以是表达式、可以是字段、可以是函数

*/
#1.查询表中的单个字段
SELECT last_name FROM employees;

#2.查询表中的多个字段
SELECT last_name,salary,email FROM employees;

#3.查询表中的所有字段
SELECT * FROM employees;

#4.查询常量值
SELECT 100;
SELECT 'John';

#5.查询表达式
SELECT 100*98

#6.查询函数
SELECT VERSION();

#7.给字段起别名
/*
（1）便于理解
（2）如果要查询的字段有重名的情况，使用别名可以区分开来
*/
#方式一：使用as
SELECT 100*98 AS 结果
SELECT last_name AS 姓,first_name AS 名 FROM employees;
#方式一：使用空格
SELECT last_name 姓,first_name 名 FROM employees;
#若别名有特殊符号的，要将别名字段加上双引号（单引号也可以）
SELECT salary AS 'out put' FROM employees;


#8.去重

#案例：查询员工表中的所有部门编号
SELECT DISTINCT department_id FROM employees;

#9.+号的作用
/*
java中的+号：
（1）运算符：两个操作数都为数值型
（2）连接符：只要有一个操作数为字符串

mysql中的+号：
仅仅只有一个功能：运算符

select 100+90; 两个操作数都为数值型，则做加法运算
select ‘123’+90;只要其中一方为字符型，试图将字符型数值转化为数值型
                 如果转换成功，则继续做加法运算
select ‘John’+90; 如果转换失败，则将字符型数值转换为0
  
select null+90; 只要其中一方为null，则结果肯定为null                

*/

#案例：查询员工名和姓连接成一个字段，并显示为 姓名
SELECT 
    CONCAT(last_name,first_name) AS 姓名 
FROM employees;

SELECT 
    CONCAT(`first_name`,',',`job_id`,',',IFNULL(`commission_pct`,0)) AS out_put
FROM employees;  
#1.	下面的语句是否可以执行成功  
SELECT last_name , job_id , salary AS sal
FROM employees; 

#2.下面的语句是否可以执行成功  
SELECT  *  FROM employees; 


#3.找出下面语句中的错误 
SELECT employee_id , last_name,
salary * 12 AS "ANNUAL  SALARY"
FROM employees;



#4.显示表departments的结构，并查询其中的全部数据

DESC departments;
SELECT * FROM `departments`;

#5.显示出表employees中的全部job_id（不能重复）
SELECT DISTINCT job_id FROM employees;

#6.显示出表employees的全部列，各个列之间用逗号连接，列头显示成OUT_PUT

SELECT 
	IFNULL(commission_pct,0) AS 奖金率,
	commission_pct
FROM 
	employees;
	
	
#-------------------------------------------

SELECT
	CONCAT(`first_name`,',',`last_name`,',',`job_id`,',',IFNULL(commission_pct,0)) AS out_put
FROM
	employees;  




