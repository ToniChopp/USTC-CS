/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2020/5/6 19:26:22                            */
/*==============================================================*/
drop database if exists lab2;
create database lab2;
use lab2;

drop trigger if exists tib_chequeaccount;

drop trigger if exists tib_client;

drop trigger if exists tib_contact;

drop trigger if exists tib_manager;

drop trigger if exists tib_saving;

drop table if exists Account;

drop table if exists BranchBank;

drop table if exists ChequeAccount;

drop table if exists Client;

drop table if exists Contact;

drop table if exists Department;

drop table if exists HeadBank;

drop table if exists Loan;

drop table if exists Manager;

drop table if exists Payment;

drop table if exists Staff;

drop table if exists lend;

drop table if exists possess;

drop table if exists possess_account;

drop table if exists saving;

drop table if exists serve;

/*==============================================================*/
/* Table: Account                                               */
/*==============================================================*/
create table Account
(
   a_id                 bigint not null,
   a_bank               varchar(40) not null,
   a_author_id          bigint not null,
   bankname             varchar(45) not null,
   a_balance            bigint not null,
   a_start_date         date not null,
   a_latest_date        datetime,
   primary key (a_id, a_bank, a_author_id)
);

/*==============================================================*/
/* Table: BranchBank                                            */
/*==============================================================*/
create table BranchBank
(
   bankname             varchar(45) not null,
   Bank                 varchar(45) not null,
   asset                double not null,
   city                 varchar(45) not null,
   primary key (bankname)
);

/*==============================================================*/
/* Table: ChequeAccount                                         */
/*==============================================================*/
create table ChequeAccount
(
   a_id                 bigint not null,
   a_bank               varchar(40) not null,
   a_author_id          bigint not null,
   bankname             varchar(45),
   a_balance            bigint not null,
   a_start_date         date not null,
   a_latest_date        datetime,
   overdraw             double,
   primary key (a_id, a_bank, a_author_id)
);

/*==============================================================*/
/* Table: Client                                                */
/*==============================================================*/
create table Client
(
   cl_id                bigint not null,
   Con_cl_id            bigint,
   cl_name              varchar(40) not null,
   cl_address           varchar(90) not null,
   cl_number            bigint not null,
   primary key (cl_id)
);

/*==============================================================*/
/* Table: Contact                                               */
/*==============================================================*/
create table Contact
(
   cl_id                bigint not null,
   con_name             varchar(40) not null,
   con_number           bigint not null,
   con_email            varchar(40) not null,
   con_relation         varchar(15) not null,
   primary key (cl_id)
);

/*==============================================================*/
/* Table: Department                                            */
/*==============================================================*/
create table Department
(
   de_id                bigint not null,
   bankname             varchar(45) not null,
   de_name              varchar(40) not null,
   type                 varchar(40) not null,
   m_id                 bigint not null,
   primary key (de_id)
);

/*==============================================================*/
/* Table: HeadBank                                              */
/*==============================================================*/
create table HeadBank
(
   Bank                 varchar(45) not null,
   primary key (Bank)
);

/*==============================================================*/
/* Table: Loan                                                  */
/*==============================================================*/
create table Loan
(
   loan_id              bigint not null,
   bankname             varchar(45) not null,
   sum_money            float not null,
   times                int not null,
   primary key (loan_id)
);

/*==============================================================*/
/* Table: Manager                                               */
/*==============================================================*/
create table Manager
(
   s_id                 bigint not null,
   de_id                bigint,
   s_name               varchar(40) not null,
   s_number             bigint not null,
   s_address            varchar(90) not null,
   s_startdate          date not null,
   primary key (s_id)
);

/*==============================================================*/
/* Table: Payment                                               */
/*==============================================================*/
create table Payment
(
   loan_id              bigint not null,
   pay_date             date not null,
   pay_money            float not null,
   primary key (loan_id)
);

/*==============================================================*/
/* Table: Staff                                                 */
/*==============================================================*/
create table Staff
(
   s_id                 bigint not null,
   de_id                bigint not null,
   s_name               varchar(40) not null,
   s_number             bigint not null,
   s_address            varchar(90) not null,
   s_startdate          date not null,
   primary key (s_id)
);

/*==============================================================*/
/* Table: lend                                                  */
/*==============================================================*/
create table lend
(
   loan_id              bigint not null,
   cl_id                bigint not null,
   primary key (loan_id, cl_id)
);

/*==============================================================*/
/* Table: possess                                               */
/*==============================================================*/
create table possess
(
   bankname             varchar(45) not null,
   cl_id                bigint not null,
   primary key (bankname, cl_id)
);

/*==============================================================*/
/* Table: possess_account                                       */
/*==============================================================*/
create table possess_account
(
   cl_id                bigint not null,
   a_id                 bigint not null,
   a_bank               varchar(40) not null,
   a_author_id          bigint not null,
   primary key (cl_id, a_id, a_bank, a_author_id)
);

/*==============================================================*/
/* Table: saving                                                */
/*==============================================================*/
create table saving
(
   a_id                 bigint not null,
   a_bank               varchar(40) not null,
   a_author_id          bigint not null,
   bankname             varchar(45),
   a_balance            bigint not null,
   a_start_date         date not null,
   a_latest_date        datetime,
   rate                 float,
   currency_type        varchar(10),
   primary key (a_id, a_bank, a_author_id)
);

/*==============================================================*/
/* Table: serve                                                 */
/*==============================================================*/
create table serve
(
   s_id                 bigint not null,
   cl_id                bigint not null,
   primary key (s_id, cl_id)
);

alter table Account add constraint FK_establish_a foreign key (bankname)
      references BranchBank (bankname) on delete restrict on update restrict;

alter table BranchBank add constraint FK_consist foreign key (Bank)
      references HeadBank (Bank) on delete restrict on update restrict;

alter table ChequeAccount add constraint FK_Inheritance_2 foreign key (a_id, a_bank, a_author_id)
      references Account (a_id, a_bank, a_author_id) on delete restrict on update restrict;

alter table Client add constraint FK_emergency_contact foreign key (Con_cl_id)
      references Contact (cl_id) on delete restrict on update restrict;

alter table Contact add constraint FK_emergency_contact2 foreign key (cl_id)
      references Client (cl_id) on delete restrict on update restrict;

alter table Department add constraint FK_owe foreign key (bankname)
      references BranchBank (bankname) on delete restrict on update restrict;

alter table Loan add constraint FK_distribute foreign key (bankname)
      references BranchBank (bankname) on delete restrict on update restrict;

alter table Manager add constraint FK_lead foreign key (s_id)
      references Staff (s_id) on delete restrict on update restrict;

alter table Payment add constraint FK_bystage foreign key (loan_id)
      references Loan (loan_id) on delete restrict on update restrict;

alter table Staff add constraint FK_have foreign key (de_id)
      references Department (de_id) on delete restrict on update restrict;

alter table lend add constraint FK_lend foreign key (loan_id)
      references Loan (loan_id) on delete restrict on update restrict;

alter table lend add constraint FK_lend2 foreign key (cl_id)
      references Client (cl_id) on delete restrict on update restrict;

alter table possess add constraint FK_possess foreign key (bankname)
      references BranchBank (bankname) on delete restrict on update restrict;

alter table possess add constraint FK_possess2 foreign key (cl_id)
      references Client (cl_id) on delete restrict on update restrict;

alter table possess_account add constraint FK_possess_account foreign key (cl_id)
      references Client (cl_id) on delete restrict on update restrict;

alter table possess_account add constraint FK_possess_account2 foreign key (a_id, a_bank, a_author_id)
      references Account (a_id, a_bank, a_author_id) on delete restrict on update restrict;

alter table saving add constraint FK_Inheritance_1 foreign key (a_id, a_bank, a_author_id)
      references Account (a_id, a_bank, a_author_id) on delete restrict on update restrict;

alter table serve add constraint FK_serve foreign key (s_id)
      references Staff (s_id) on delete restrict on update restrict;

alter table serve add constraint FK_serve2 foreign key (cl_id)
      references Client (cl_id) on delete restrict on update restrict;


create trigger tib_chequeaccount before insert
on ChequeAccount for each row
begin
end;


create trigger tib_client before insert
on Client for each row
begin
end;


create trigger tib_contact before insert
on Contact for each row
begin
end;


create trigger tib_manager before insert
on Manager for each row
begin
end;


create trigger tib_saving before insert
on saving for each row
begin
end;

