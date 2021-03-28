SHOW DATABASES;
USE myemployees;


#进阶3：排序查询
/*
语法：
select 查询列表
from 表名
【where  筛选条件】
order by 排序的字段或表达式;


特点：
1、asc代表的是升序，可以省略(系统默认的是升序）
desc代表的是降序

2、order by子句可以支持 单个字段、别名、表达式、函数、多个字段

3、order by子句在查询语句的最后面，除了limit子句

*/

#案例1、按单个字段排序
SELECT * FROM employees ORDER BY salary DESC;  #降序
SELECT * FROM employees ORDER BY salary ASC;   #升序

# 案例2：查询部门编号>=90的员工信息，并按入职日期降序   【添加筛选条件】
SELECT * 
FROM 
	employees 
WHERE 
	department_id >=90
ORDER BY hiredate DESC;
	

#按表达式排序
#案例3：按年薪的高低显示员工的信息和年薪
SELECT *,salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY salary*12 DESC;


#案例4：按年薪的高低显示员工的信息和年薪【按别名排序】
SELECT *,salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY 年薪 DESC;


#5、按函数排序
#案例5：按姓名的长度显示员工的姓名和工资
SELECT LENGTH(last_name) AS 字节长度,last_name,salary
FROM employees
ORDER BY LENGTH(last_name);

#6、按多个字段排序
#案例6：查询员工信息，要求先按工资降序，再按employee_id升序
#(当有几个人工资相同时，就按照employee_id对这几个人的顺序进行排序）
SELECT * FROM employees
ORDER BY salary DESC,employee_id ASC;


# 【测试题】
#1.查询员工的姓名和部门号和年薪，按年薪降序 按姓名升序
SELECT 
	last_name,
	department_id,
	salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM
	employees
ORDER BY 年薪 DESC,last_name ASC;


#2.选择工资不在8000到17000的员工的姓名和工资，按工资降序
SELECT 
	last_name,
	salary
FROM
	employees
WHERE
	salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC;

#3.查询邮箱中包含e的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT *
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC,department_id ASC;






