﻿CREATE DATABASE XAY_DUNG_MAIL_SERVER
GO

USE XAY_DUNG_MAIL_SERVER
GO

--Bảng thông tin mật khẩu ứng dụng
CREATE TABLE dbo.MATKHAU_LOCAL
(
	id int IDENTITY(1, 1),
	id_MATKHAU_LOCAL AS 'PL' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	USERNAME_LOCAL varchar(50) NOT NULL UNIQUE,
	PASSWORD_LOCAL varchar(50) NOT NULL,

	CONSTRAINT PK_MATKHAU_LOCAL PRIMARY KEY(id)
)
GO

--Bảng thông tin tên miền và cổng gửi mail
CREATE TABLE dbo.DOMAIN_MAIL
(
	id int IDENTITY(1, 1),
	id_DOMAIN_MAIL AS 'DP' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	DOMAIN varchar(100) NOT NULL,
	PORT_MAIL int NOT NULL,

	CONSTRAINT PK_DOMAIN_MAIL PRIMARY KEY(id)
)
GO

--Bảng thông tin mật khẩu mail
CREATE TABLE dbo.MATKHAU_MAIL
(
	id int IDENTITY(1, 1),
	id_MATKHAU_MAIL AS 'PM' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	USERNAME_MAIL varchar(50) NOT NULL,
	PASSWORD_MAIL varchar(50) NOT NULL,
	
	FK_id_DOMAIN_MAIL int NULL,
	FK_id_MATKHAU_LOCAL int NULL

	CONSTRAINT PK_MATKHAU_MAIL PRIMARY KEY(id),
	CONSTRAINT FK_MATKHAU_MAIL_DOMAIN_MAIL FOREIGN KEY(FK_id_DOMAIN_MAIL) REFERENCES dbo.DOMAIN_MAIL(id) 
	on update cascade
	on delete cascade,
	CONSTRAINT FK_MATKHAU_MAIL_MATKHAU_LOCAL FOREIGN KEY(FK_id_MATKHAU_LOCAL) REFERENCES dbo.MATKHAU_LOCAL(id) 
	on update cascade
	on delete cascade
)
GO

--Bảng thông tin trạng thái mail
CREATE TABLE dbo.TRANG_THAI
(
	id int IDENTITY(1, 1),
	id_TRANG_THAI AS 'TT' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	DANHDAU bit DEFAULT 0,
	XOATHU bit DEFAULT 0,
	STATUS_MAIL bit DEFAULT 0, 
	SEND_RECEIVE bit DEFAULT 0,
	UPDATE_TIME_MAIL date NULL

	CONSTRAINT PK_TRANG_THAI PRIMARY KEY(id)
)
GO

--Bảng thông tin nội dung mail
CREATE TABLE dbo.NOIDUNG_MAIL
(
	id int IDENTITY(1, 1),
	id_NOIDUNG_MAIL AS 'ND' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	TO_MAIL nvarchar(2000) NOT NULL,
	FROM_MAIL nvarchar(2000) NOT NULL,
	SUBJECT_MAIL nvarchar(200) NOT NULL,
	CONTENT_MAIL AS RIGHT(CONVERT(VARCHAR(5), id), 6) + '.html' PERSISTED,
	PATH_ATTACH nvarchar(500) NULL,

	FK_id_TRANG_THAI int NULL

	CONSTRAINT PK_NOIDUNG_MAIL PRIMARY KEY(id),

	CONSTRAINT FK_NOIDUNG_MAIL_TRANG_THAI FOREIGN KEY(FK_id_TRANG_THAI) REFERENCES dbo.TRANG_THAI(id) 
	on update cascade
	on delete cascade,
)
GO

--Bảng thông tin danh sách mail đã gửi
CREATE TABLE dbo.DANHSACH_MAIL
(
	id int IDENTITY(1, 1),
	id_DANHSACH_MAIL AS 'DM' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	THOIGIAN_GUI date NULL,

	FK_id_MATKHAU_MAIL int NULL,
	FK_id_NOIDUNG_MAIL int NULL,

	CONSTRAINT PK_DANHSACH_MAIL PRIMARY KEY(id),
	CONSTRAINT FK_DANHSACH_MAIL_MATKHAU_MAIL FOREIGN KEY(FK_id_MATKHAU_MAIL) REFERENCES dbo.MATKHAU_MAIL(id) 
	on update cascade
	on delete cascade,
	CONSTRAINT FK_DANHSACH_MAIL_NOIDUNG_MAIL FOREIGN KEY(FK_id_NOIDUNG_MAIL) REFERENCES dbo.NOIDUNG_MAIL(id)
	on update cascade
	on delete cascade
)
GO

--Bảng thông tin khách hàng
CREATE TABLE dbo.THONGTIN_CLIENT
(
	id int IDENTITY(1, 1),
	id_KHACHHANG AS 'KH' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

	HO nvarchar(10) NOT NULL,
	TEN	nvarchar(20) NOT NULL,
	EMAIL varchar(50) NOT NULL UNIQUE,
	NTNS date NOT NULL,
	GIOITINH int NULL,
	NGAYTAOTK date NULL,
	MAPIN int NOT NULL DEFAULT 0,
	
	FK_id_MATKHAU_LOCAL int NULL

	CONSTRAINT PK_THONGTIN_CLIENT PRIMARY KEY(id),
	CONSTRAINT FK_THONGTIN_CLIENT_MATKHAU_LOCAL FOREIGN KEY(FK_id_MATKHAU_LOCAL) REFERENCES dbo.MATKHAU_LOCAL(id) 
	on update cascade
	on delete cascade
)
GO

--Tài khoản Admin
--CREATE TABLE dbo.ADMIN_MAIL
--(
--	id int IDENTITY(1, 1),
--	id_ADMIN_MAIL AS 'AD' + RIGHT(CONVERT(VARCHAR(5), id), 6) PERSISTED,

--	USERNAMEAD varchar(50) NOT NULL UNIQUE,
--	PASSWORDAD varchar(50) NOT NULL,
--	HO nvarchar(50) NOT NULL,
--	TEN nvarchar(50) NOT NULL,
--	NTNS nvarchar(50) NOT NULL,
--	CHUCVU nvarchar(50) NOT NULL

--	CONSTRAINT PK_ADMIN_MAIL PRIMARY KEY(id)
--)
--GO


SET IDENTITY_INSERT [dbo].[DOMAIN_MAIL] ON 

INSERT [dbo].[DOMAIN_MAIL] ([id], [DOMAIN], [PORT_MAIL]) VALUES (1, N'smtp.gmail.com', 587)
INSERT [dbo].[DOMAIN_MAIL] ([id], [DOMAIN], [PORT_MAIL]) VALUES (2, N'smtp.mail.yahoo.com', 587)
INSERT [dbo].[DOMAIN_MAIL] ([id], [DOMAIN], [PORT_MAIL]) VALUES (3, N'smtp-mail.outlook.com', 587)
SET IDENTITY_INSERT [dbo].[DOMAIN_MAIL] OFF
GO