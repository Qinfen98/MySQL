#进阶4：常见函数

/*

概念：类似于java的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
好处：1、隐藏了实现细节  2、提高代码的重用性
调用：select 函数名(实参列表) 【from 表】;
特点：
	①叫什么（函数名）
	②干什么（函数功能）

分类：
	1、单行函数
	如 concat、length、ifnull等
	2、分组函数
	
	功能：做统计使用，又称为统计函数、聚合函数、组函数
	
常见函数：
	一、单行函数
	
	字符函数：
	length:获取字节个数(utf-8一个汉字代表3个字节,gbk为2个字节)
	concat
	substr
	instr
	trim
	upper
	lower
	lpad
	rpad
	replace
	
	数学函数：
	round
	ceil
	floor
	truncate
	mod
	
	日期函数：
	now
	curdate
	curtime
	year
	month
	monthname
	day
	hour
	minute
	second
	str_to_date
	date_format
	其他函数：
	version
	database
	user
	控制函数
	if
	case


	

*/

# 一、字符函数
# 1.length() 获取参数值的字节个数
SELECT LENGTH('john');
SELECT LENGTH('张三丰hahaha');

SHOW VARIABLES LIKE '%char%'

# 2.concat 拼接字符串
SELECT CONCAT(last_name,'_',first_name) FROM employees;

#3. upper、lower
SELECT UPPER('john');
SELECT LOWER('john');

# 示例：将姓变大写，将名变小写，然后拼接
SELECT CONCAT(UPPER(last_name),'_',LOWER(first_name)) AS 姓名
FROM employees;

# 4.substr、sunstring  （索引从1开始）

# 截取从指定索引处后面的所有字符
SELECT SUBSTR('李莫愁爱上了陆展元',7) AS out_put;

# 截取从指定索引处指定字符长度的字符
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) AS out_put;


# 案例：姓名中首字符大写，其他字符小写，然后用_拼接，显示出来
SELECT CONCAT(UPPER(SUBSTR(last_name,1,1)),'_',LOWER(SUBSTR(last_name,2))) AS out_put
FROM employees;


# 5.instr  返回字串第一次出现的索引，如果找不到则返回0
SELECT INSTR('杨不悔爱上了殷六侠','殷六侠') AS out_put;

# 6.trim   去掉字符串两边的量
SELECT LENGTH(TRIM('    行三丰    ')) AS out_put;
SELECT TRIM('a' FROM 'aaaaa行aaaaaa三丰aaaaaaaaaa') AS out_put;

# 7.lpad  用指定的字符实现左填充指定长度
SELECT LPAD('殷素素',10,'*');

# 8.rpad  用指定的字符实现右填充指定长度
SELECT RPAD('殷素素',10,'*');

# 9.replace 替换
SELECT REPLACE('张无忌爱上了周芷若','周芷若','赵敏');


# 二、数学函数

# 1. round   四舍五入
SELECT ROUND(1.67)
SELECT ROUND(1.855,2)     # 保留两位小数

# 2.ceil    向上取整   返回>=该参数的最小整数
SELECT CEIL(1.23)

# 3.floor   向下取整   返回<=该参数的最大整数
SELECT FLOOR(8.88);

# 4.truncate   截断
SELECT TRUNCATE(1.699999,2);

# 5.mod  取余
SELECT MOD(10,3);
SELECT 10%3;


# 三、日期函数

# 1.now    返回当前系统日期+时间
SELECT NOW();

# 2.curdate   返回当前系统日期，不包含时间
SELECT CURDATE();

# 3.curtime    返回当前系统时间，不包含日期
SELECT CURTIME();


# 4.可以获取指定的部门：年、月、日、小时、分钟、秒
SELECT YEAR(NOW()) AS 年;
SELECT YEAR('1998-01-01') AS 年;

SELECT YEAR(hiredate) AS 年 FROM employees;

SELECT MONTH(NOW()) AS 月;
SELECT MONTHNAME(NOW()) AS 月;

# 5. str_to_date   将字符通过指定的格式转化为日期
SELECT STR_TO_DATE('1998-3-2','%Y-%c-%d') AS out_put;

# 查询入职日期为1992-4-3的员工信息
SELECT * FROM employees WHERE hiredate = '1992-4-3';

SELECT * FROM employees WHERE hiredate = STR_TO_DATE('4-3-1992','%c-%d-%Y');


# 6.date_format    将日期转换成字符
SELECT DATE_FORMAT(NOW(),'%y年%m月%d日') AS out_put;

# 查询有奖金的员工名和入职日期(xx月xx日 xx年)
SELECT last_name,DATE_FORMAT(hiredate,'%m月/%d日 %y年') 
FROM employees
WHERE commission_pct IS NOT NULL;


# 四、其他函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

# 五、流程控制函数
# 1. if函数    if else的效果

SELECT IF(10 < 5,'大','小');

SELECT last_name,commission_pct,
IF(commission_pct IS NULL,'没奖金，呵呵','有奖金，嘻嘻') AS 备注
FROM employees;


#2.case函数的使用一：
/*

case 要判断的字段或表达式
when 常量1 then 要显示的值1或语句1;
when 常量2 then 要显示的值2或语句2;
...
else 要显示的值n或语句n;
end
*/

/*案例：查询员工的工资，要求
部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍
其他部门，显示的工资为原工资

*/

SELECT salary AS 原始工资,department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary 
END AS 新工资
FROM employees;

#3.case函数的使用二：

/*case 
when 条件1 then 要显示的值1或语句1
when 条件2 then 要显示的值2或语句2
。。。
else 要显示的值n或语句n
end
*/

/*案例：查询员工的工资的情况
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资>10000，显示C级别
否则，显示D级别
*/

SELECT salary,
CASE
WHEN salary > 20000 THEN 'A'
WHEN salary > 15000 THEN 'B'
WHEN salary > 10000 THEN 'C'
ELSE 'D'
END AS 工资级别
FROM employees;


# 【测试题】
#1.	显示系统时间(注：日期+时间)
SELECT NOW();

#2.	查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
SELECT employee_id,last_name,salary,salary*1.2 AS "new salary"
FROM employees;

#3.	将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT last_name,LENGTH(last_name) AS 长度,SUBSTR(last_name,1,1) AS 首字符
FROM employees
ORDER BY 首字符;


#4.	做一个查询，产生下面的结果
<last_name> earns <salary> monthly but wants <salary*3>
Dream Salary
King earns 24000 monthly but wants 72000

SELECT CONCAT(last_name,' earns ', salary,' monthly but wants ', salary*3) AS "Dream Salary"
FROM employees
WHERE salary = 24000;


#5.	使用case-when，按照下面的条件：
job                  grade
AD_PRES            A
ST_MAN             B
IT_PROG             C
SA_REP              D
ST_CLERK           E
产生下面的结果
Last_name	Job_id	Grade
king	AD_PRES	A


SELECT last_name,job_id AS job,
CASE job_id
WHEN "AD_PRES" THEN "A"
WHEN "ST_MAN " THEN "B"
WHEN "IT_PROG" THEN "C"
WHEN "SA_REP" THEN "D"
WHEN "ST_CLERK" THEN "E"
END AS grade
FROM employees
WHERE job_id = 'AD_PRES';




#二、分组函数
/*
功能：用作统计使用，又称为聚合函数或统计函数或组函数

分类：
sum 求和、avg 平均值、max 最大值 、min 最小值 、count 计算个数

特点：
1、sum、avg一般用于处理数值型
   max、min、count可以处理任何类型
2、以上分组函数都忽略null值

3、可以和distinct搭配实现去重的运算

4、count函数的单独介绍
一般使用count(*)用作统计行数

5、和分组函数一同查询的字段要求是group by后的字段

*/


#1、简单 的使用
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT COUNT(salary) FROM employees;

SELECT SUM(salary) AS 和,AVG(salary) AS 平均,MAX(salary) AS 最高,MIN(salary) AS 最低,COUNT(salary) AS 个数
FROM employees;

SELECT SUM(salary) AS 和,ROUND(AVG(salary),2) AS 平均,MAX(salary) AS 最高,MIN(salary) AS 最低,COUNT(salary) AS 个数
FROM employees;


#2、参数支持哪些类型

SELECT SUM(last_name) ,AVG(last_name) FROM employees;
SELECT SUM(hiredate) ,AVG(hiredate) FROM employees;

SELECT MAX(last_name),MIN(last_name) FROM employees;

SELECT MAX(hiredate),MIN(hiredate) FROM employees;

SELECT COUNT(commission_pct) FROM employees;
SELECT COUNT(last_name) FROM employees;

#3、是否忽略null

SELECT SUM(commission_pct) ,AVG(commission_pct),SUM(commission_pct)/35,SUM(commission_pct)/107 FROM employees;

SELECT MAX(commission_pct) ,MIN(commission_pct) FROM employees;

SELECT COUNT(commission_pct) FROM employees;
SELECT commission_pct FROM employees;

# 和distinct搭配（去重）
SELECT SUM(DISTINCT salary),SUM(salary) FROM employees;
SELECT COUNT(DISTINCT salary),COUNT(salary) FROM employees;


# 5.count函数的详细介绍
SELECT COUNT(commission_pct) FROM employees;     #不会把空值计入进去
SELECT COUNT(*) FROM employees;     #查看该表的行数
SELECT COUNT(1) FROM employees;     #查看该表的行数，括号里是任何变量值都可以

#效率：
#MYISAM存储引擎下  ，COUNT(*)的效率高
#INNODB存储引擎下，COUNT(*)和COUNT(1)的效率差不多，比COUNT(字段)要高一些


#分组函数的案例讲解
#1.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary) AS 最大值,MIN(salary) AS 最小值,AVG(salary) AS 平均值,
SUM(salary) AS 总和 FROM employees;

#2.查询员工表中的最大入职时间和最小入职时间的相差天数 （DIFFRENCE）
SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) AS DIFFRENCE FROM employees;

#3.查询部门编号为90的员工个数
SELECT COUNT(*) FROM employees WHERE department_id = 90;



