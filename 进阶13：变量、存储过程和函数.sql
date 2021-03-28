#变量
/*
系统变量：
	全局变量
	会话变量

自定义变量：
	用户变量
	局部变量

*/

#一、系统变量
/*
说明：变量由系统定义，不是用户定义，属于服务器层面
注意：全局变量需要添加global关键字，会话变量需要添加session关键字，如果不写，默认会话级别
使用步骤：
1、查看所有系统变量
show global|【session】variables;
2、查看满足条件的部分系统变量
show global|【session】 variables like '%char%';
3、查看指定的系统变量的值
select @@global|【session】系统变量名;
4、为某个系统变量赋值
方式一：
set global|【session】系统变量名=值;
方式二：
set @@global|【session】系统变量名=值;

*/

#1全局变量
/*
作用域：针对于所有会话（连接）有效，但不能跨重启
*/
#①查看所有全局变量
SHOW GLOBAL VARIABLES;

#②查看满足条件的部分系统变量
SHOW GLOBAL VARIABLES LIKE "%char%";

#③查看指定的系统变量的值
SELECT @@global.autocommit;
SELECT @@tx_isolation;

#④为某个系统变量赋值
SET @@global.autocommit = 0;
SET GLOBAL autocommit = 0;


#2》会话变量
/*
作用域：针对于当前会话（连接）有效
*/
#①查看所有会话变量
SHOW SESSION VARIABLES;
SHOW VARIABLES;

#②查看满足条件的部分会话变量
SHOW SESSION VARIABLES LIKE "%char%";
SHOW VARIABLES LIKE "%char%";

#③查看指定的会话变量的值
SELECT @@autocommit;
SELECT @@session.tx_isolation;

#④为某个会话变量赋值
SET @@session.tx_isolation = 'read-uncommitted';
SET SESSION tx_isolation = 'read-committed';


#二、自定义变量
/*
说明：变量由用户自定义，而不是系统提供的
使用步骤：
1、声明
2、赋值
3、使用（查看、比较、运算等）
*/

#1》用户变量
/*
作用域：针对于当前会话（连接）有效，作用域同于会话变量
*/

#赋值操作符：=或:=
#①声明并初始化
SET @变量名=值;
SET @变量名:=值;
SELECT @变量名:=值;

#②赋值（更新变量的值）
#方式一：
	SET @变量名=值;
	SET @变量名:=值;
	SELECT @变量名:=值;
#方式二：
	SELECT 字段 INTO @变量名
	FROM 表;
#③使用（查看变量的值）
SELECT @变量名;


#2》局部变量
/*
作用域：仅仅在定义它的begin end块中有效
应用在 begin end中的第一句话
*/

#①声明
DECLARE 变量名 类型;
DECLARE 变量名 类型 【DEFAULT 值】;


#②赋值（更新变量的值）

#方式一：
	SET 局部变量名=值;
	SET 局部变量名:=值;
	SELECT 局部变量名:=值;
#方式二：
	SELECT 字段 INTO 具备变量名
	FROM 表;
#③使用（查看变量的值）
SELECT 局部变量名;




#用户变量和局部变量的对比

		作用域			定义位置		语法
用户变量	当前会话		会话的任何地方		加@符号，不用指定类型
局部变量	定义它的BEGIN END中 	BEGIN END的第一句话	一般不用加@,需要指定类型
			



#案例：声明两个变量并赋初始值，求和并打印

#用户变量
SET @m = 1;
SET @n = 2;
SET @sum = @m + @n;
SELECT @sum;

# 局部变量
DECLARE m INT DEFAULT 1;
DECLARE n INT DEFAULT 2;
DECLARE SUM INT;
SET SUM = m + n;
SELECT SUM;
# 报错，因为局部变量只能在BEGIN END的第一句话




#存储过程和函数
/*
存储过程和函数：类似于java中的方法
好处：
1、提高代码的重用性
2、简化操作



*/
#存储过程
/*
含义：一组预先编译好的SQL语句的集合，理解成批处理语句
1、提高代码的重用性
2、简化操作
3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率



*/


#一、创建语法

CREATE PROCEDURE 存储过程名(参数列表)
BEGIN

	存储过程体（一组合法的SQL语句）
END

#注意：
/*
1、参数列表包含三部分
参数模式  参数名  参数类型
举例：
in stuname varchar(20)

参数模式：
in：该参数可以作为输入，也就是该参数需要调用方传入值
out：该参数可以作为输出，也就是该参数可以作为返回值
inout：该参数既可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值

2、如果存储过程体仅仅只有一句话，begin end可以省略
存储过程体中的每条sql语句的结尾要求必须加分号。
存储过程的结尾可以使用 delimiter 重新设置
语法：
delimiter 结束标记        【任何字符都可以作为结束标记】
案例：
delimiter $
*/


#二、调用语法

CALL 存储过程名(实参列表);

#--------------------------------案例演示-----------------------------------
#1.空参列表
#案例：插入到admin表中五条记录
SELECT * FROM admin;

DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username,`password`)
	VALUES('jack',3333),('rose',3333),('tom',3333),('lulu',3333),('lily',3333);

END $


#调用
CALL myp1();

SELECT * FROM admin;


#2.创建带in模式参数的存储过程

#案例1：创建存储过程实现 根据女神名，查询对应的男神信息
DELIMITER $
CREATE PROCEDURE myp2(IN beautyname VARCHAR(20))
BEGIN
	SELECT bo.*
	FROM boys AS bo
	RIGHT JOIN beauty AS b ON b.boyfriend_id = bo.id
	WHERE b.name = beautyname;

END$


#调用
CALL myp2('周冬雨');

#案例2 ：创建存储过程实现，用户是否登录成功

CREATE PROCEDURE myp3(IN username VARCHAR(20),IN PASSWORD VARCHAR(20))
BEGIN
	DECLARE result INT DEFAULT 0;  # 声明并初始化
	
	SELECT COUNT(*) INTO result   # 赋值
	FROM admin
	WHERE admin.`username`=username
	AND admin.`password`=PASSWORD;
	
	SELECT IF(result > 0,'成功','失败');   #调用

END;

# 调用
CALL myp3('张飞','9999');



#3.创建out 模式参数的存储过程
#案例1：根据输入的女神名，返回对应的男神名
DELIMITER $
CREATE PROCEDURE myp4(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20))

BEGIN
	SELECT boys.`boyName` INTO boyName
	FROM boys
	INNER JOIN beauty ON boys.`id`=beauty.`boyfriend_id`
	WHERE beauty.`name` = beautyName;

END$

# 调用
CALL myp4('周冬雨',@bname);
SELECT @bname;


#案例2：根据输入的女神名，返回对应的男神名和魅力值
DELIMITER $
CREATE PROCEDURE myp5(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20),OUT userCp INT)

BEGIN
	SELECT boys.`boyName`,boys.`userCP` INTO boyName,userCP     #赋值
	FROM boys
	INNER JOIN beauty ON boys.`id`=beauty.`boyfriend_id`
	WHERE beauty.`name` = beautyName;

END$

# 调用
CALL myp5('周冬雨',@bname,@usercp);
SELECT @bname,@usercp;




#4.创建带inout模式参数的存储过程
#案例1：传入a和b两个值，最终a和b都翻倍并返回
DELIMITER $
CREATE PROCEDURE myp6(INOUT a INT,INOUT b INT)
BEGIN
	SET a = a*2;
	SET b = b*2;

END$

# 调用
SET @m = 10;
SET @n = 20;
CALL myp6(@m,@n);
SELECT @m,@n;


# 【案例讲解】
#一、创建存储过程实现传入用户名和密码，插入到admin表中
DELIMITER $

CREATE PROCEDURE test_pro1(IN username VARCHAR(20),IN loginpwd VARCHAR(20))
BEGIN
	INSERT INTO admin(username,`password`)
	VALUES(username,loginpwd);

END$

CALL test_pro1('admin','0000');
SELECT * FROM admin;

#二、创建存储过程实现传入女神编号，返回女神名称和女神电话
DELIMITER $

CREATE PROCEDURE test_pro3(IN id INT,OUT bName VARCHAR(20),OUT bPhone INT)
BEGIN
	SELECT b.name,b.phone INTO bName,bPhone
	FROM beauty AS b
	WHERE b.id = id;

END$

CALL test_pro3(2,@m,@p);
SELECT @m,@p;

#三、创建存储存储过程或函数实现传入两个女神生日，返回大小

DELIMITER $

CREATE PROCEDURE test_pro4(IN birth1 DATETIME,IN birth2 DATETIME,OUT result INT)
BEGIN
	SELECT DATEDIFF(birth1,birth2) INTO result;
	
END$

CALL test_pro4('1989-10-21',NOW(),@result);
SELECT @result;




#三、删除存储过程
#语法：drop procedure 存储过程名
DROP PROCEDURE p1;    # 只能一次删除一个存储过程
DROP PROCEDURE p2,p3;#××  不可行

DROP PROCEDURE test_pro2;


#四、查看存储过程的信息
DESC myp2;   # ×  不可行
SHOW CREATE PROCEDURE  myp2;




# 【案例讲解】

#四、创建存储过程或函数实现传入一个日期，格式化成xx年xx月xx日并返回
DELIMITER $
CREATE PROCEDURE test_pro5(IN mydate DATETIME,OUT strDate VARCHAR(50))
BEGIN
	SELECT DATE_FORMAT(mydate,'%y年%m月%d日') INTO strDate;

END $

CALL test_pro4(NOW(),@str);
SELECT @str;



#五、创建存储过程或函数实现传入女神名称，返回：女神 and 男神  格式的字符串
如 传入 ：小昭
返回： 小昭 AND 张无忌


DELIMITER $
CREATE PROCEDURE test_pro6(IN beautyName VARCHAR(20),OUT str VARCHAR(50))
BEGIN
	SELECT CONCAT(beautyName,'and',IFNULL(boyName,'null')) INTO str
	FROM boys AS bo 
	RIGHT JOIN beauty AS b ON b.boyfriend_id = bo.id
	WHERE b.name = beautyName;

END $

CALL test_pro6('周冬雨',@str);
SELECT @str;


#六、创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录
DELIMITER $

CREATE PROCEDURE test_pro7(IN size INT,IN startindex INT)
BEGIN
	SELECT * FROM beauty LIMIT startindex,size;

END $

CALL test_pro7(5,3);









#函数
/*
含义：一组预先编译好的SQL语句的集合，理解成批处理语句
1、提高代码的重用性
2、简化操作
3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率

区别：

存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
函数：有且仅有1 个返回，适合做处理数据后返回一个结果

*/

#一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN
	函数体
END
/*

注意：
1.参数列表 包含两部分：
参数名 参数类型

2.函数体：肯定会有return语句，如果没有会报错
如果return语句没有放在函数体的最后也不报错，但不建议

return 值;
3.函数体中仅有一句话，则可以省略begin end
4.使用 delimiter语句设置结束标记

*/

#二、调用语法
SELECT 函数名(参数列表)


#------------------------------案例演示----------------------------
#1.无参有返回
#案例：返回公司的员工个数
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0;     # 定义变量
	SELECT COUNT(*) INTO c      # 赋值
	FROM employees;
	RETURN c;	

END $

SELECT myf1() $

#2.有参有返回
#案例1：根据员工名，返回它的工资
DELIMITER $
CREATE FUNCTION myf2(empName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal = 0;   #定义用户变量
	SELECT salary INTO @sal
	FROM employees
	WHERE last_name = empName;
	
	RETURN @sal;

END $

SELECT(myf2('kochhar'))   $



#案例2：根据部门名，返回该部门的平均工资
DELIMITER $
CREATE FUNCTION myf3(deptName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE sal DOUBLE;
	SELECT AVG(salary) INTO sal
	FROM employees AS e
	INNER JOIN departments AS d ON e.department_id = d.department_id
	WHERE d.department_name = deptName;
	
	RETURN sal;
	
END $

SELECT(myf3('IT')) $


#三、查看函数
SHOW CREATE FUNCTION myf3;

#四、删除函数
DROP FUNCTION myf3;




#案例
#一、创建函数，实现传入两个float，返回二者之和

DELIMITER $
CREATE FUNCTION myf4(f1 FLOAT,f2 FLOAT)  RETURNS FLOAT
BEGIN
	DECLARE twosum FLOAT DEFAULT 0;
	SET twosum = f1 + f2;
	RETURN twosum;
	
END $

SELECT myf4(1.2,2.3) $








#流程控制结构
/*
顺序、分支、循环

*/

#一、分支结构
#1.if函数
/*
语法：if(条件,值1，值2)
功能：实现双分支
应用在begin end中或外面

*/

#2.case结构
/*
语法：
情况1：类似于switch
case 变量或表达式
when 值1 then 语句1;
when 值2 then 语句2;
...
else 语句n;
end 

情况2：
case 
when 条件1 then 语句1;
when 条件2 then 语句2;
...
else 语句n;
end 

应用在begin end 中或外面


*/

#3.if结构

/*
语法：
if 条件1 then 语句1;
elseif 条件2 then 语句2;
....
else 语句n;
end if;
功能：类似于多重if

只能应用在begin end 中

*/

#案例1：创建存储过程，实现传入成绩，如果成绩>90,显示A，如果成绩>80,显示B，如果成绩>60,显示C，否则显示D
DELIMITER $
CREATE PROCEDURE test_case(IN score INT)
BEGIN
	CASE
	WHEN score >= 90 AND score <= 100 THEN SELECT 'A';
	WHEN score >= 80 THEN SELECT 'B';
	WHEN score >= 60 THEN SELECT 'C';
	ELSE SELECT 'D';
	END CASE;	

END $

CALL test_case(90);



#案例2：创建函数，实现传入成绩，如果成绩>90,返回A，如果成绩>80,返回B，如果成绩>60,返回C，否则返回D

DELIMITER $
CREATE FUNCTION test_if(score INT) RETURNS CHAR
BEGIN
	IF score>=90 AND score<=100 THEN RETURN 'A';
	ELSEIF score>=80 THEN RETURN 'B';
	ELSEIF score>=60 THEN RETURN 'C';
	ELSE RETURN 'D';
	END IF;	

END $

SELECT test_if(67) $




#二、循环结构
/*
分类：
while、loop、repeat

循环控制：

iterate类似于 continue，继续，结束本次循环，继续下一次
leave 类似于  break，跳出，结束当前所在的循环

*/

#1.while
/*

语法：

【标签:】while 循环条件 do
	循环体;
end while【 标签】;

联想：

while(循环条件){

	循环体;
}

*/

#2.loop
/*

语法：
【标签:】loop
	循环体;
end loop 【标签】;

可以用来模拟简单的死循环



*/

#3.repeat
/*
语法：
【标签：】repeat
	循环体;
until 结束循环的条件
end repeat 【标签】;


*/

#1.没有添加循环控制语句
#案例：批量插入，根据次数插入到admin表中多条记录
DELIMITER $
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;
	WHILE i < insertCount DO
		INSERT INTO admin(username,`password`) VALUES(CONCAT('Rose',i),'666');
		SET i = i+1;
		END WHILE;

END $

CALL pro_while1(100);



#2.添加leave语句

#案例：批量插入，根据次数插入到admin表中多条记录，如果次数>20则停止
TRUNCATE TABLE admin;
DROP PROCEDURE pro_while1;

DELIMITER $
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;
	a:WHILE i < insertCount DO
		INSERT INTO admin(username,`password`) VALUES(CONCAT('xiaoming',i),'666');
		IF i >= 20 THEN LEAVE a;
		END IF;
		SET i = i+1;
	END WHILE a;

END $

CALL pro_while1(100);



#3.添加iterate语句

#案例：批量插入，根据次数插入到admin表中多条记录，只插入偶数次

TRUNCATE TABLE admin;
DROP PROCEDURE pro_while1;

DELIMITER $
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;
	a:WHILE i < insertCount DO
		SET i = i+1;
		IF MOD(i,2) != 0 THEN ITERATE a;
		END IF;
		
		INSERT INTO admin(username,`password`) VALUES(CONCAT('xiaoming',i),'666');
				
	END WHILE a;

END $

CALL pro_while1(100);



# [案例讲解]

/*一、已知表stringcontent
其中字段：
id 自增长
content varchar(20)

向该表插入指定个数的，随机的字符串
*/
DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(20)
	
);
DELIMITER $
CREATE PROCEDURE test_randstr_insert(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE str VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
	DECLARE startIndex INT;#代表初始索引
	DECLARE len INT;#代表截取的字符长度
	WHILE i<=insertcount DO
		SET startIndex=FLOOR(RAND()*26+1);#代表初始索引，随机范围1-26
		SET len=FLOOR(RAND()*(20-startIndex+1)+1);#代表截取长度，随机范围1-（20-startIndex+1）
		INSERT INTO stringcontent(content) VALUES(SUBSTR(str,startIndex,len));
		SET i=i+1;
	END WHILE;

END $

CALL test_randstr_insert(10)$













