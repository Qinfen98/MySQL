# 进阶2：条件查询
SHOW DATABASES;
USE myemployees;
/*
语法：
   select 
         查询列表
   from      
         表名
   where      
         筛选条件;

分类：

    一、按条件表达式筛选
    简单条件运算符：> < = != <> >= <=
    
    二、按逻辑表达式筛选
    逻辑运算符：
             &&   ||   ！
             and  or   not
             	
	&&和and：两个条件都为true，结果为true，反之为false
	||或or： 只要有一个条件为true，结果为true，反之为false
	!或not： 如果连接的条件本身为false，结果为true，反之为false
             
    三、模糊查询
        like 
        between and
        in
        is null
        
*/

#一、按条件表达式筛选
#案例1：查询工资>12000的员工信息
SELECT 
      *
FROM
     employees
WHERE
     salary>12000;

#案例2：查询部门编号不等于90号的员工名和部门编号
SELECT 
      `first_name`,`last_name`,`department_id`
FROM
     employees
WHERE
     department_id<>90;


   #二、按逻辑表达式筛选
#案例1：查询工资z在10000到20000之间的员工名、工资以及奖金
SELECT 
      last_name,salary,commission_pct
FROM
     employees
WHERE
     salary>=10000 AND salary <=20000;

#案例2：查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT 
      *
FROM
     employees
WHERE
     department_id >110 OR department_id <90 OR salary>15000

#三、模糊查询
/*
like
特点：
①一般和通配符搭配使用
	通配符：
	% 任意多个字符,包含0个字符
	_ 任意单个字符

	
	
between and
①使用between and 可以提高语句的简洁度
②包含临界值
③两个临界值不要调换顺序

in
含义：判断某字段的值是否属于in列表中的某一项
特点：
	①使用in提高语句简洁度
	②in列表的值类型必须一致或兼容
	③in列表中不支持通配符
	
	
is null|is not null
=或<>不能用于判断null值
is null或is not null 可以判断null值

*/

#1.like
#案例1：查询员工名中包含字符a的员工信息
SELECT
	*
FROM
	employees
WHERE
	last_name LIKE '%a%';

#案例2：查询员工名中第三个字符为n，第五个字符为l的员工名和工资
SELECT
	last_name,
	salary
FROM
	employees
WHERE
	last_name LIKE '__n_l%';
	

#案例3：查询员工名中第二个字符为_的员工名
SELECT
	last_name
FROM
	employees
WHERE
	last_name LIKE '_\_%';
	#或者last_name LIKE '_$_%' escape '$';通过escape转译的方式也可以达到这样的效果


#2.between and
#案例1：查询员工编号在100到120之间的员工信息
SELECT 
	*
FROM
	employees
WHERE
	employee_id >=100 AND employee_id <=120;
*---------------------------------	
#案例1：查询员工编号在100到120之间的员工信息
SELECT 
	*
FROM
	employees
WHERE
	employee_id BETWEEN 100 AND 120;


#3.in
#案例：查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES中的一个员工名和工种编号

SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	job_id = 'IT_PROT' OR job_id = 'AD_VP' OR JOB_ID ='AD_PRES';

#----------------------------------------
SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	job_id IN ('IT_PROT','AD_VP' ,'AD_PRES');

#4、is null
#案例1：查询没有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct IS NULL;
#----以下为错误------
SELECT
	last_name,
	commission_pct
FROM
	employees
WHERE
	salary IS 12000;


#安全等于  <=>     (就是等于的含义）


#案例1：查询没有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct <=>NULL;
	
	
#案例2：查询工资为12000的员工信息
SELECT
	last_name,
	salary
FROM
	employees

WHERE 
	salary <=> 12000;
	

#is null pk <=>

IS NULL:仅仅可以判断NULL值，可读性较高，建议使用
<=>    :既可以判断NULL值，又可以判断普通的数值，可读性较低


#案例讲解（复习）
#查询员工号为176的员工的姓名、部门号和年薪
SELECT
	last_name,
	department_id,
	salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM
	employees
WHERE
	employee_id=176;


#测试1：查询没有奖金，且工资小于18000的salary,last_name
SELECT
	salary,
	last_name
FROM
	employees
WHERE
	commission_pct IS NULL AND salary<18000;

#测试2：查询employees表中，job_id不为‘IT’或者工资为12000的员工信息
SELECT
	*
FROM
	employees
WHERE
	job_id <> 'IT' OR salary=12000;

#测试3：查看部门departments表的结构
DESC departments;

#测试4：查询部门departments表中涉及了哪些位置编号
SELECT DISTINCT
	location_id
FROM
	departments;


#测试5：经典面试题
#试问：select * from employees 和
#select * from employees where commission_pct like '%%' and last_name like '%%'
#结果是否一样，并说明原因

/*不一样！判断的字段commission_pct有null值，用and连接，得出的结果不是全部的值*/

/*习题练习

1.  查询工资大于 12000 的员工姓名和工资
2.  查询员工号为 176 的员工的姓名和部门号和年薪
3.  选择工资不在 5000 到 12000 的员工的姓名和工资
4.  选择在 20 或 50 号部门工作的员工姓名和部门号
5.  选择公司中没有管理者的员工姓名及 job_id
6.  选择公司中有奖金的员工姓名，工资和奖金级别
7.  选择员工姓名的第三个字母是 a 的员工姓名
8.  选择姓名中有字母 a 和 e 的员工姓名
9.  显示出表 employees 表中 first_name 以 'e'结尾的员工信息
10. 显示出表 employees 部门编号在 80-100 之间 的姓名、职位
11. 显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、职位
*/

# 1.  查询工资大于 12000 的员工姓名和工资
SELECT
	last_name,
	salary
FROM
	employees
WHERE
	salary > 12000;

#2.  查询员工号为 176 的员工的姓名和部门号和年薪
SELECT
	last_name,
	department_id,
	salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM
	employees
WHERE
	employee_id = 176;


# 3.  选择工资不在 5000 到 12000 的员工的姓名和工资
SELECT
	last_name,
	salary
FROM
	employees
WHERE
	salary NOT BETWEEN 5000 AND 12000;


#4.  选择在 20 或 50 号部门工作的员工姓名和部门号
SELECT
	last_name,
	department_id
FROM
	employees
WHERE
	department_id = 20 OR department_id = 50;

# 5.  选择公司中没有管理者的员工姓名及 job_id
SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	manager_id IS NULL;

# 6.  选择公司中有奖金的员工姓名，工资和奖金级别
SELECT
	last_name,
	salary,
	commission_pct
FROM
	employees
WHERE
	commission_pct IS NOT NULL;

# 7.  选择员工姓名的第三个字母是 a 的员工姓名
SELECT
	last_name
FROM
	employees
WHERE
	last_name LIKE '__a%';


# 8.  选择姓名中有字母 a 和 e 的员工姓名  (不会做这个）

# 9.  显示出表 employees 表中 first_name 以 'e'结尾的员工信息
SELECT
	*
FROM
	employees
WHERE
	first_name LIKE '%e'

# 10. 显示出表 employees 部门编号在 80-100 之间 的姓名、职位
SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	department_id BETWEEN 80 AND 100;


# 11. 显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、职位
SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	manager_id IN (100,101,110);


