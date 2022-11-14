use master
go
if exists (select * from sysdatabases where name = 'QTMT')
	DROP DATABASE QTMT
go
create database QTMT
go
use QTMT
if exists (select * from sysobjects where name = 'SanPham')
	drop table SanPham
create table SanPham(
	Masanpham varchar(10) primary key,
	Tensanpham varchar(30),
	ghichu varchar(30),
	dongia int,
)


if exists (select * from sysobjects where name = 'Insert_Sanpham')
	drop table Insert_Sanpham
go
create function Insert_Sanpham (@Tensanpham varchar(30), @Ghichu varchar(30), @dongia int)
returns int
as
begin
	Declare @Masanpham varchar (30)
	Declare @SP varchar(10)
	Declare @STT int
	set @STT = (select count(*) from Sanpham)+1
	set @SP = (case when @STT <10 then 'SP00' else 'SP0' end)
	set @Masanpham = @SP + cast(@STT as varchar(5))
	Declare @Av nvarchar(1000)
	set @Av = 'insert into SanPham values('+''''+@Masanpham+''''+','+''''+@Tensanpham+''''+','+''''+@Ghichu+''''+','+cast(@dongia as varchar(30))+')'
	execute sp_executesql @Av
	return 1
end
go

if exists (select  * from sysobjects where name = 'check_dongia')
	drop trigger check_dongia
go
create trigger check_dongia on SanPham
after insert
as
	declare @dongia int
	select @dongia = dongia from inserted
	declare @gia int
	set @gia = @dongia
	if (@gia < 0)
	begin
		raiserror('Luong khong hop le',16,1)
		rollback tran
	end
go


insert into SanPham values('SP001','Hang hoa','Hoan thien',25000)
insert into SanPham values('SP002','Hang hoa','Hoan thien',-25000)
insert into SanPham values('SP003','Hang hoa','Hoan thien',25000)
insert into SanPham values('SP004','Hang hoa','Hoan thien',25000)
select * from SanPham