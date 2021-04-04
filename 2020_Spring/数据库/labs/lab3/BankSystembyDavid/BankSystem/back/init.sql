drop database if exists bank;
create database if not exists bank; 
use bank;

create table sub_bank (
	sb_name	VARCHAR(20)		not null,
	sb_city		VARCHAR(20)		not null,
	sb_assets		FLOAT			not null,
	constraint PK_SUBBANK primary key (sb_name)
);

create table department (
	d_code		CHAR(20)			not null,
    d_name		VARCHAR(20)		not null,
    d_type		VARCHAR(20)     not null,
    d_m_identity_code			CHAR(20),
    d_sb_name			VARCHAR(20),
    constraint PK_DEPARTMENT primary key (d_code),
	Constraint FK_BANK_DEPART Foreign Key(d_sb_name) References sub_bank(sb_name)
);

create table staff (
	s_identity_code			CHAR(18)		not null,
    s_name			VARCHAR(20)		not null,
    s_phone		CHAR(11),
    s_address			VARCHAR(50),
    s_start_work_date		DATE			not null,
    s_d_code			CHAR(20),
    constraint PK_STAFF primary key (s_identity_code),
	Constraint FK_D_CODE Foreign Key(s_d_code) References department(d_code)
);

create table manager(
    m_identity_code CHAR(20) not null,
    m_d_code CHAR(20) not null,
    constraint PK_MANAGER primary key (m_identity_code),
    Constraint FK_MANAGERID Foreign Key(m_identity_code) References staff(s_identity_code),
    Constraint FK_DEPARTID Foreign Key(m_d_code) References department(d_code)
);

create table customer (
	c_identity_code			CHAR(18)		not null,
	c_name			VARCHAR(10)		not null,
	c_phone		CHAR(11)		not null,
	c_address			VARCHAR(50),
	c_contact_phone	CHAR(11)		not null,
	c_contact_name	VARCHAR(10)		not null,
	c_contact_email	VARCHAR(20),
	c_contact_relationship		VARCHAR(10)		not null,
    c_loan_staff_identity_code			CHAR(18),
    c_account_staff_identity_code			CHAR(18),
	constraint PK_CUSTOMER primary key (c_identity_code),
    Constraint FK_CL_LOAN Foreign Key(c_loan_staff_identity_code) References staff(s_identity_code),
    Constraint FK_CL_ACCOUNT Foreign Key(c_account_staff_identity_code) References staff(s_identity_code)
);

create table account(
	a_code		CHAR(20)			not null,
	a_balance			FLOAT			not null,
    a_open_date			DATE       not null,
	a_open_bank		VARCHAR(20) not null,
	constraint PK_ACCOUT primary key (a_code),
	Constraint FK_OPENBANK Foreign Key(a_open_bank) References sub_bank(sb_name)
);

create table savings_account (
	sa_a_code		CHAR(20)			not null,
    sa_rate	        float           not null,
    sa_currency_type  CHAR(20)      not null,
    constraint PK_SACODE primary key (sa_a_code),
	Constraint FK_SAACODE Foreign Key(sa_a_code) References account(a_code) On Delete Cascade
);

create table checking_account (
	ca_a_code		CHAR(20)			not null, 
    ca_credit		FLOAT               not null,
    constraint PK_CAACODE primary key (ca_a_code),
	Constraint FK_CODE Foreign Key(ca_a_code) References account(a_code) On Delete Cascade
);

create table loan (
	l_code			CHAR(20)			not null,
    l_money			FLOAT,
    l_sb_name 			VARCHAR(20),
    l_state			CHAR(1)			default '0',
    constraint PK_LCODE primary key (l_code),
	Constraint FK_SBNAME Foreign Key(l_sb_name) References sub_bank(sb_name)
);

create table loan_payment (
	lp_code			CHAR(20),
    lp_l_code       CHAR(20),
    lp_date			DATE    not null,
    lp_money		FLOAT   not null,
    constraint PK_PAYMENT primary key (lp_code, lp_l_code),
    constraint FK_LPLCODE Foreign Key(lp_l_code) References loan(l_code) On Delete Cascade
);  

create table checking_account_record (
    car_last_visit_time  DATE   not null,
    car_c_identity_code CHAR(20),
    car_sb_name VARCHAR(20),
    car_a_code CHAR(20) not null,
    constraint PK_CAR primary key (car_c_identity_code, car_sb_name),
    constraint FK_CCI Foreign Key (car_c_identity_code) references customer(c_identity_code),
    constraint FK_CSBN Foreign Key (car_sb_name) references sub_bank(sb_name),
    constraint FK_CACD Foreign Key (car_a_code) references account(a_code)
);

create table savings_account_record (
    sar_last_visit_time  DATE   not null,
    sar_c_identity_code CHAR(20),
    sar_sb_name VARCHAR(20),
    sar_a_code CHAR(20) not null,
    constraint PK_SAR primary key (sar_c_identity_code, sar_sb_name),
    constraint FK_SCI Foreign Key (sar_c_identity_code) references customer(c_identity_code),
    constraint FK_SSBN Foreign Key (sar_sb_name) references sub_bank(sb_name),
    constraint FK_SACD Foreign Key (sar_a_code) references account(a_code)
);

create table loan_customer(
    lc_l_code  CHAR(20),
    lc_c_identity_code    CHAR(20),
    constraint PK_LCL primary key (lc_l_code, lc_c_identity_code),
    constraint FK_LCLLC foreign key (lc_l_code) references loan(l_code),
    constraint FK_LCLCLIC foreign key (lc_c_identity_code) references customer(c_identity_code)
);

INSERT INTO sub_bank values('Beijing Bank', 'Beijing', 0.0);
INSERT INTO sub_bank values('Shanghai Bank', 'Shanghai', 0.0);
INSERT INTO sub_bank values('Hefei Bank', 'Hefei', 0.0);
INSERT INTO sub_bank values('Guangzhou Bank', 'Guangzhou', 0.0);
INSERT INTO sub_bank values('Shenzhen Bank', 'Shenzhen', 0.0);

INSERT INTO department values('depart_1', '市场部', '普通', null, null);
INSERT INTO department values('depart_2', '市场部', '普通',null,null);
INSERT INTO department values('depart_3', '市场部', '特殊',null,null);
INSERT INTO department values('depart_4', '人事部', '普通',null,null);
INSERT INTO department values('depart_5', '人事部', '普通',null,null);
INSERT INTO department values('depart_6', '人事部', '特殊',null,null);

INSERT INTO staff values('staff_1', 'staffA', '13312312345', '合肥市蜀山区', '2012-01-11', 'depart_1');
INSERT INTO staff values('staff_2', 'staffB', '13323323333', '芝加哥南区', '2020-01-10', 'depart_2');
INSERT INTO staff values('staff_3', 'staffC', '13323311451', '芝加哥北区', '2020-01-10', 'depart_3');
INSERT INTO staff values('staff_4', 'staffD', '17344455555', '华莱士大街', '2020-01-10', 'depart_4');
INSERT INTO staff values('staff_5', 'staffE', '18912345678', '合肥市包河区', '2018-01-31', 'depart_5');
INSERT INTO staff values('staff_6', 'staffF', '13012345678', '合肥市包河区', '2018-03-22', 'depart_2');
INSERT INTO staff values('staff_7', 'staffG', '18900011100', '合肥市蜀山区', '2018-10-31', 'depart_3');
INSERT INTO staff values('staff_8', 'staffH', '18912321232', '巢湖', '2020-01-31', 'depart_6');

INSERT INTO manager values('staff_1', 'depart_1');
INSERT INTO manager values('staff_2', 'depart_2');
INSERT INTO manager values('staff_3', 'depart_3');
INSERT INTO manager values('staff_4', 'depart_4');
INSERT INTO manager values('staff_5', 'depart_5');
INSERT INTO manager values('staff_8', 'depart_6');

UPDATE department SET d_m_identity_code = 'staff_1' WHERE d_code = 'depart_1';
UPDATE department SET d_sb_name = 'Beijing Bank' WHERE d_code = 'depart_1';
UPDATE department SET d_m_identity_code = 'staff_2' WHERE d_code = 'depart_2';
UPDATE department SET d_sb_name = 'Beijing Bank' WHERE d_code = 'depart_2';
UPDATE department SET d_m_identity_code = 'staff_3' WHERE d_code = 'depart_3';
UPDATE department SET d_sb_name = 'Shanghai Bank' WHERE d_code = 'depart_3';
UPDATE department SET d_m_identity_code = 'staff_4' WHERE d_code = 'depart_4';
UPDATE department SET d_sb_name = 'Guangzhou Bank' WHERE d_code = 'depart_4';
UPDATE department SET d_m_identity_code = 'staff_5' WHERE d_code = 'depart_5';
UPDATE department SET d_sb_name = 'Hefei Bank' WHERE d_code = 'depart_5';
UPDATE department SET d_m_identity_code = 'staff_8' WHERE d_code = 'depart_6';
UPDATE department SET d_sb_name = 'Shenzhen Bank' WHERE d_code = 'depart_6';