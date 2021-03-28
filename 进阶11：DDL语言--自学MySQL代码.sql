#DDL
/*

数据定义语言

库和表的管理

一、库的管理
创建、修改、删除

二、表的管理
创建、修改、删除

创建： create
修改： alter
删除： drop

*/

#一、库的管理
#1、库的创建
/*
语法：
create database  [if not exists] 库名;
*/


#案例：创建库Books
CREATE DATABASE books;

CREATE DATABASE IF NOT EXISTS books;  # 创建的库重名，但是不想要数据库报错，添加容错性
# 如果库名存在，就不创建了；库名不存在就创建



#2、库的修改
# 更改库的字符集
ALTER DATABASE books CHARACTER SET utf8;

# 3.库的删除
DROP DATABASE IF EXISTS books;   # 如果存在，就删除




#二、表的管理
#1.表的创建 ★

/*
语法：
create table 表名(
	列名 列的类型【(长度) 约束】,
	列名 列的类型【(长度) 约束】,
	列名 列的类型【(长度) 约束】,
	...
	列名 列的类型【(长度) 约束】

)

*/
#案例：创建表Book
CREATE TABLE Book(
	id INT,   # 编号
	bName VARCHAR(20),    # 图书名
	price DOUBLE,   # 价格
	authorID INT,    # 作者编号
	publishDate DATETIME    # 出版日期

);




#案例：创建表author
CREATE TABLE author(
	id INT,
	au_name VARCHAR(20),
	nation VARCHAR(10)
);

DESC author;


#2.表的修改

/*
语法
alter table 表名 add|drop|modify|change column 列名 【列类型 约束】;

*/

#①修改列名   alter table 表名 change column 旧列名 新列名【列类型 约束】;
ALTER TABLE book CHANGE COLUMN publishDate pubDate DATETIME;

#②修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;

#③添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;

#④删除列
ALTER TABLE author DROP COLUMN annual;


#⑤修改表名
ALTER TABLE author RENAME TO book_author;


#3.表的删除
DROP TABLE IF EXISTS book_author;

#通用的写法：

DROP DATABASE IF EXISTS 旧库名;
CREATE DATABASE 新库名;


DROP TABLE IF EXISTS 旧表名;
CREATE TABLE  表名();



#4.表的复制
INSERT INTO author VALUES
(1,'村上春树','日本'),
(2,'莫言','中国'),
(3,'冯唐','中国'),
(4,'金庸','中国');

SELECT * FROM author;

#1.仅仅复制表的结构
CREATE TABLE copy LIKE author;

#2.复制表的结构+数据
CREATE TABLE copy2 
SELECT * FROM author;

#3.只复制部分数据
CREATE TABLE copy3
SELECT id,au_name
FROM author
WHERE nation = '中国';

# 4.仅仅复制某些字段
CREATE TABLE copy4 
SELECT id,au_name
FROM author
WHERE 0;


# 【案例讲解】
#1.创建表dept1
NAME	NULL?	TYPE
id		INT(7)
NAME		VARCHAR(25)

USE test;
CREATE TABLE dept1(
	id INT(7),
	NAME VARCHAR(25)
);


#2.将表departments中的数据插入新表dept2中 （可以跨库去复制表结构）
CREATE TABLE dept2
SELECT department_id,department_name
FROM myemployees.`departments`;


#3.	创建表emp5
NAME	NULL?	TYPE
id		INT(7)
First_name	VARCHAR (25)
Last_name	VARCHAR(25)
Dept_id		INT(7)

CREATE TABLE emp5(
	id INT(7),
	First_name VARCHAR(25),
	Last_name VARCHAR(25),
	Dept_id INT(7)
);


#4.将列Last_name的长度增加到50
ALTER TABLE emp5 MODIFY COLUMN Last_name VARCHAR(50);


#5.	根据表employees创建employees2
CREATE TABLE employees2 LIKE myemployees.`employees`;


#6.	删除表emp5
DROP TABLE IF EXISTS emp5;

#7.	将表employees2重命名为emp5
ALTER TABLE employees2 RENAME TO emp5;

#8.在表dept和emp5中添加新列test_column，并检查所作的操作
ALTER TABLE emp5 ADD COLUMN test_column VARCHAR(15);
 

#9.直接删除表emp5中的列 dept_id
ALTER TABLE emp5 DROP COLUMN Dept_id;







#常见的数据类型
/*
数值型：
	整型
	小数：
		定点数
		浮点数
字符型：
	较短的文本：char、varchar
	较长的文本：text、blob（较长的二进制数据）

日期型：
	


*/

#一、整型
/*
分类：
tinyint、smallint、mediumint、int/integer、bigint
1	 2		3	4		8

特点：
① 如果不设置无符号还是有符号，默认是有符号，如果想设置无符号，需要添加unsigned关键字
② 如果插入的数值超出了整型的范围,会报out of range异常，并且插入临界值
③ 如果不设置长度，会有默认的长度
长度代表了显示的最大宽度，如果不够会用0在左边填充，但必须搭配zerofill使用！

*/

#1.如何设置无符号和有符号
CREATE TABLE tab_int(
	t1 INT,
	t2 INT UNSIGNED
);
DESC tab_int;
INSERT INTO tab_int VALUES(-100,-100);

SELECT * FROM tab_int;



#二、小数
/*
分类：
1.浮点型
float(M,D)
double(M,D)
2.定点型
dec(M，D)
decimal(M,D)

特点：

①
M：整数部位+小数部位
D：小数部位
如果超过范围，则插入临界值

②
M和D都可以省略
如果是decimal，则M默认为10，D默认为0
如果是float和double，则会根据插入的数值的精度来决定精度

③定点型的精确度较高，如果要求插入数值的精度较高如货币运算等则考虑使用


*/

#测试M和D
DROP TABLE tab_float;
CREATE TABLE tab_float(
	f1 FLOAT,
	f2 DOUBLE,
	f3 DECIMAL
);

INSERT INTO tab_float VALUES(123.4566,123.4566,123.4566);
INSERT INTO tab_float VALUES(123.456,123.456,123.456);
INSERT INTO tab_float VALUES(123.4,123.4,123.4);

SELECT * FROM tab_float;
INSERT INTO tab_float VALUES(1523.45,1523.45,1523.45);

DESC tab_float;


#原则：
/*
所选择的类型越简单越好，能保存数值的型越小越好

*/

#三、字符型（串数据类型）
/*
较短的文本：

char
varchar

其他：

binary和varbinary用于保存较短的二进制
enum用于保存枚举
set用于保存集合


较长的文本：
text
blob(较大的二进制)

特点：



	写法		M的意思					特点			空间的耗费	效率
char	char(M)		最大的字符数，可以省略，默认为1		固定长度的字符		比较耗费	高

varchar varchar(M)	最大的字符数，不可以省略		可变长度的字符		比较节省	低
*/


# 枚举  ENUM
CREATE TABLE tab_char(
	c1 ENUM('a','b','c')
);

INSERT INTO tab_char VALUES ('a');
INSERT INTO tab_char VALUES ('b');
INSERT INTO tab_char VALUES ('c');
INSERT INTO tab_char VALUES ('m');
INSERT INTO tab_char VALUES ('A');    # 不区分大小写

SELECT * FROM tab_char;



CREATE TABLE tab_set(
	s1 SET('a','b','c','d')
);

INSERT INTO tab_set VALUES ('a');
INSERT INTO tab_set VALUES ('a,b');
INSERT INTO tab_set VALUES ('a,c,d');


SELECT * FROM tab_set;


#四、日期型

/*

分类：
date保存日期
time 只保存时间
year只保存年

datetime保存日期+时间
timestamp保存日期+时间   范围较小


特点：

		字节		范围		            时区等的影响
datetime	8		1000——9999	                  不受
timestamp	4	        1970-2038	                    受

*/

CREATE TABLE tab_date(
	t1 DATETIME,
	t2 TIMESTAMP
);

INSERT INTO tab_date VALUES (NOW(),NOW());

SELECT * FROM tab_date;


SHOW VARIABLES LIKE 'time_zone';

SET time_zone='+9:00';



#常见约束

/*


含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确和可靠性


分类：六大约束
	NOT NULL：非空，用于保证该字段的值不能为空
	比如姓名、学号等
	DEFAULT:默认，用于保证该字段有默认值
	比如性别
	PRIMARY KEY:主键，用于保证该字段的值具有唯一性，并且非空
	比如学号、员工编号等
	UNIQUE:唯一，用于保证该字段的值具有唯一性，可以为空
	比如座位号
	CHECK:检查约束【mysql中不支持】
	比如年龄、性别
	FOREIGN KEY:外键，用于限制两个表的关系，用于保证该字段的值必须来自于主表的关联列的值
		在从表添加外键约束，用于引用主表中某列的值
	比如学生表的专业编号，员工表的部门编号，员工表的工种编号
	

添加约束的时机：
	1.创建表时
	2.修改表时
	

约束的添加分类：
	列级约束：
		六大约束语法上都支持，但外键约束没有效果
		
	表级约束：
		
		除了非空、默认，其他的都支持
		
		
主键和唯一的大对比：

		保证唯一性  是否允许为空    一个表中可以有多少个   是否允许组合
	主键	√		×		至多有1个           √，但不推荐
	唯一	√		√		可以有多个          √，但不推荐
外键：
	1、要求在从表设置外键关系
	2、从表的外键列的类型和主表的关联列的类型要求一致或兼容，名称无要求
	3、主表的关联列必须是一个key（一般是主键或唯一）
	4、插入数据时，先插入主表，再插入从表
	删除数据时，先删除从表，再删除主表


*/

CREATE TABLE 表名(
	字段名 字段类型 列级约束,
	字段名 字段类型,
	表级约束

)
CREATE DATABASE students;
#一、创建表时添加约束

#1.添加列级约束
/*
语法：

直接在字段名和类型后面追加 约束类型即可。

只支持：默认、非空、主键、唯一



*/


CREATE DATABASE students;
USE students;

CREATE TABLE stuinfo(
	id INT PRIMARY KEY,    # 主键
	stuName VARCHAR(20) NOT NULL,   # 非空
	gender CHAR(1) CHECK(gender = '男' OR gender = '女'),   #检查
	seat INT UNIQUE,    # 唯一
	age INT DEFAULT 18,    #默认值
	majorId INT REFERENCES major(id)   # 外键

);

CREATE TABLE major(
	id INT PRIMARY KEY,
	majorName VARCHAR(20)

);

DESC stuinfo;

# 查看stuinfo表中所有的索引，包括主键、外键、唯一
SHOW INDEX FROM stuinfo;




#2.添加表级约束      不支持默认和非空
/*

语法：在各个字段的最下面
 【constraint 约束名】 约束类型(字段名)    # 约束名自己起
*/
DROP TABLE stuinfo;

CREATE TABLE stuinfo(
	id INT,   
	stuName VARCHAR(20),  
	gender CHAR(1) ,  
	seat INT ,   
	age INT,
	majorId INT,
	
	CONSTRAINT pk PRIMARY KEY(id), # 主键
	CONSTRAINT uq UNIQUE(seat),  #唯一
	CONSTRAINT ck CHECK(gender = '男' OR gender = '女'),   #检查
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)  #外键
	    
);

SHOW INDEX FROM stuinfo;




#通用的写法：★

CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY,
	stuname VARCHAR(20),
	sex CHAR(1),
	age INT DEFAULT 18,
	seat INT UNIQUE,
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)

);



#二、修改表时添加约束

/*
1、添加列级约束
alter table 表名 modify column 字段名 字段类型 新约束;

2、添加表级约束
alter table 表名 add 【constraint 约束名】 约束类型(字段名) 【外键的引用】;


*/


DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT
)
DESC stuinfo;
#1.添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20)  NOT NULL;
#2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;

#3.添加主键
#①列级约束
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;
#②表级约束
ALTER TABLE stuinfo ADD PRIMARY KEY(id);

#4.添加唯一

#①列级约束
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
#②表级约束
ALTER TABLE stuinfo ADD UNIQUE(seat);


#5.添加外键
ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id); 




#三、修改表时删除约束

#1.删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NULL;

#2.删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT ;

#3.删除主键
ALTER TABLE stuinfo DROP PRIMARY KEY;

#4.删除唯一
ALTER TABLE stuinfo DROP INDEX seat;

#5.删除外键
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stuinfo_major;

SHOW INDEX FROM stuinfo;




# 【案例讲解】
#1.向表emp2的id列中添加PRIMARY KEY约束（my_emp_id_pk）
ALTER TABLE emp2 MODIFY COLUMN id INT PRIMARY KEY;
ALTER TABLE emp2 ADD CONSTRAINT my_emp_id_pk PRIMARY KEY id;


#2.向表dept2的id列中添加PRIMARY KEY约束（my_dept_id_pk）

#3.向表emp2中添加列dept_id，并在其中定义FOREIGN KEY约束，与之相关联的列是dept2表中的id列。
ALTER TABLE emp2 ADD COLUMN dept_id INT;
ALTER TABLE emp2 CONSTRAINT fk_emp2_dept2 FOREIGN KEY(dept_id) REFERENCES dept2(id);





		位置		支持的约束类型			是否可以起约束名
列级约束：	列的后面	语法都支持，但外键没有效果	不可以
表级约束：	所有列的下面	默认和非空不支持，其他支持	可以（主键没有效果）








