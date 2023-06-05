--schema master
create table master.category(
	cate_id serial primary key
)

alter table master.category
add column cate_name varchar(255) unique not null;

create table master.status(
	status varchar(15) primary key
)
--select * from master.category

-------------------------------------------------------------------------------------------------------------

--schema curriculum
create table curriculum.program_entity (
	prog_entity_id serial primary key
)

alter table curriculum.program_entity
add column prog_title varchar(256) not null;

select * from curriculum.program_entity;

-------------------------------------------------------------------------------------------------------------


--schema users	
create table users.users(
	user_entity_id int primary key
)
-------------------------------------------------------------------------------------------------------------

--schema payment
create table payment.transaction_payment(
	trpa_code_number varchar(55) unique
)

-------------------------------------------------------------------------------------------------------------

--schema sales
--table special offer referensi dari module master
create table sales.special_offer (
	spof_id serial primary key,
	spof_discount integer not null,
	spof_type varchar(15) not null,
	spof_start_date timestamp not null,
	spof_end_date timestamp not null,
	spof_min_qty integer not null,
	spof_max_qty integer not null,
	spof_modified_date timestamp not null default current_timestamp,
	spof_cate_id integer references master.category(cate_id) on delete cascade	
)
--drop table sales.special_offer
--select * from sales.special_offer;

create table sales.special_offer_programs(
	soco_id serial primary key,
	soco_spof_id integer references sales.special_offer(spof_id) on delete cascade,
	soco_prog_entity_id integer references curriculum.program_entity(prog_entity_id) on delete cascade,
	soco_status varchar(15) check (soco_status in ('open','cancelled','closed')),
	soco_modified_date timestamp default current_timestamp
)
--drop table sales.special_offer_programs;
--select * from sales.special_offer_programs;

create table sales.sales_order_header(
	sohe_id serial primary key,
	sohe_order_date timestamp not null,
	sohe_due_time timestamp not null,
	sohe_ship_date timestamp not null,
	sohe_order_number varchar(25) unique not null,
	sohe_account_number varchar(25) not null,
	sohe_trpa_code_number varchar(25) not null,
	sohe_subtotal integer not null,
	sohe_tax integer not null,
	sohe_total_due integer not null,
	sohe_license_code varchar(512) unique not null,
	sohe_modified_date timestamp default current_timestamp,
	sohe_user_entity_id integer references users.users(user_entity_id) on delete cascade,
	sohe_status varchar(15) references master.status(status) check (sohe_status in ('open','shipping','cancelled','refund'))
)

alter table sales.sales_order_header
drop constraint sales_order_header_sohe_trpa_code_number_fkey,
add constraint sales_order_header_sohe_trpa_code_number_fkey
foreign key (sohe_trpa_code_number)
references payment.transaction_payment(trpa_code_number)
on delete cascade;

alter table sales.sales_order_header
drop constraint sales_order_header_sohe_status_fkey,
add constraint sales_order_header_sohe_status_fkey
foreign key (sohe_status)
references master.status(status)
on delete cascade;

--select * from sales.sales_order_header;


create table sales.sales_order_detail(
	sode_id serial primary key,
	sode_qty integer not null,
	sode_unit_price integer not null,
	sode_unit_discount integer not null,
	sode_line_total integer not null,
	sode_modified_date timestamp default current_timestamp,
	sode_sohe_id integer references sales.sales_order_header(sohe_id) on delete cascade,
	sode_prog_entity_id integer references curriculum.program_entity(prog_entity_id) on delete cascade
)

--drop table sales.sales_order_detail;


create table sales.cart_items (
	cait_id serial primary key,
	cait_quantity integer not null,
	cait_unit_price integer not null,
	cait_modified_date timestamp default current_timestamp,
	cait_user_entity_id integer references users.users(user_entity_id) on delete cascade,
	cait_prog_entity_id integer references curriculum.program_entity(prog_entity_id) on delete cascade
)

--drop table sales.cart_items;

-------------------------------------------------------------------------------------------------------------------------

--insert data

insert into curriculum.program_entity(prog_title)
values ('percobaan1');

insert into master.category(cate_name)
values ('percobaan1');

------------------------------------------------------------------------------------------------------------------------

--store procedure

create or replace procedure public.insertspecialoffer (in data json)
language 'plpgsql'
as $BODY$
declare new_spof_id int;
begin
with spof_id as (
	insert into sales.special_offer(spof_discount,spof_type,spof_start_date,spof_end_date,spof_min_qty,spof_max_qty,spof_cate_id)
	select spof_discount,spof_type,spof_start_date,spof_end_date,spof_min_qty,spof_max_qty,spof_cate_id
	from json_to_recordset(data)
)

	




