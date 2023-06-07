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
alter table sales.special_offer
add column spof_description varchar(256) not null;

alter table sales.special_offer
alter column spof_start_date type date,
alter column spof_end_date type date

ALTER TABLE sales.special_offer
ALTER COLUMN spof_start_date SET NOT NULL,
ALTER COLUMN spof_end_date SET NOT NULL;

--drop table sales.special_offer
select * from sales.special_offer;

create table sales.special_offer_programs(
	soco_id serial primary key,
	soco_spof_id integer references sales.special_offer(spof_id) on delete cascade,
	soco_prog_entity_id integer references curriculum.program_entity(prog_entity_id) on delete cascade,
	soco_status varchar(15) check (soco_status in ('open','cancelled','closed')),
	soco_modified_date timestamp default current_timestamp
)
--drop table sales.special_offer_programs;
select * from sales.special_offer_programs;

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
alter column sohe_order_date type date,
alter column sohe_due_time type date,
alter column sohe_ship_date type date;

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
values ('percobaan2');

insert into master.category(cate_name)
values ('percobaan2');

insert into payment.transaction_payment(trpa_code_number)
values ('TR-20230525-00001')

insert into sales.sales_order_header(sohe_order_date,sohe_due_time,sohe_ship_date,sohe_order_number,sohe_account_number,sohe_trpa_code_number,sohe_subtotal,sohe_tax,sohe_total_due,sohe_license_code,sohe_user_entity_id,sohe_status)
values ('2023-06-07','2023-06-08','2023-06-09','orderpertama01','wiwiwiwiwi','TR-20230525-00001','')
call sales.insertspecialoffer(
'[
	{
		"spof_description":"percobaan kedua memasukkan data",
		"spof_discount":9,
		"spof_type":"apa",
		"spof_start_date":"2023-10-10",
		"spof_end_date":"2023-11-30",
		"spof_min_qty":1,
		"spof_max_qty":10,
		"spof_cate_id":1,
		"soco_prog_entity_id":1,
		"soco_status":"closed"
	},
	{
		"spof_description":"percobaan ketiga memasukkan data",
		"spof_discount":30,
		"spof_type":"sembarang",
		"spof_start_date":"2022-09-01",
		"spof_end_date":"2022-10-30",
		"spof_min_qty":6,
		"spof_max_qty":11,
		"spof_cate_id":2,
		"soco_prog_entity_id":2,
		"soco_status":"cancelled"
	}
	]'
);

CALL sales.insertsalesorders('[
{
    "order_date": "2023-06-06",
    "due_time": "2023-06-07",
    "ship_date": "2023-06-08",
    "order_number": "ORD001",
    "account_number": "ACC001",
    "trpa_code_number": "TRP001",
    "subtotal": 100,
    "tax": 10,
    "total_due": 110,
    "license_code": "LICENSE001",
    "user_entity_id": 1,
    "status": "open",
	"item":[
		{
            "qty": 2,
            "unit_price": 50,
            "unit_discount": 5,
            "line_total": 95,
            "prog_entity_id": 10
        },
        {
            "qty": 1,
            "unit_price": 30,
            "unit_discount": 2,
            "line_total": 28,
            "prog_entity_id": 20
        }					
	]
}]')
------------------------------------------------------------------------------------------------------------------------

--store procedure 

CREATE OR REPLACE PROCEDURE sales.insertspecialoffer(
	IN data json)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    new_spof_id INTEGER;
BEGIN
    WITH spof_id AS (
        INSERT INTO sales.special_offer (spof_description, spof_discount, spof_type, spof_start_date, spof_end_date, spof_min_qty, spof_max_qty, spof_cate_id)
        SELECT spof_description, spof_discount, spof_type, spof_start_date::DATE, spof_end_date::DATE, spof_min_qty, spof_max_qty, spof_cate_id
        FROM json_to_recordset(data) AS special_offer (spof_description varchar,spof_discount INTEGER, spof_type VARCHAR, spof_start_date TEXT, spof_end_date TEXT, spof_min_qty INTEGER, spof_max_qty INTEGER, spof_cate_id INTEGER)
        RETURNING spof_id
    )
    SELECT spof_id INTO new_spof_id FROM spof_id;

    INSERT INTO sales.special_offer_programs (soco_prog_entity_id, soco_status, soco_spof_id)
    SELECT soco_prog_entity_id, soco_status, new_spof_id
    FROM json_to_recordset(data) AS special_offer_programs (soco_prog_entity_id INTEGER, soco_status VARCHAR);

    COMMIT;
END
$BODY$;


CREATE OR REPLACE PROCEDURE sales.insertsalesorders(
	IN data json)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    header_id INTEGER;
BEGIN
    -- Insert into sales_order_header table
    with orderId as (
		insert into sales.sales_order_header(sohe_order_date,sohe_due_time,sohe_ship_date,sohe_order_number,sohe_account_number,sohe_trpa_code_number,sohe_subtotal,sohe_tax,sohe_total_due,sohe_license_code,sohe_user_entity_id,sohe_status)
		select sohe_order_date::DATE,sohe_due_time::DATE,sohe_ship_date::DATE,sohe_order_number,sohe_account_number,sohe_trpa_code_number,sohe_subtotal,sohe_tax,sohe_total_due,sohe_license_code,sohe_user_entity_id,sohe_status
		from json_to_recordset (data) as sales_order_header (sohe_order_date TEXT,sohe_due_time TEXT,sohe_ship_date TEXT,sohe_order_number varchar,sohe_account_number varchar, sohe_trpa_code_number varchar,sohe_subtotal integer,sohe_tax integer,sohe_total_due integer,sohe_license_code varchar,sohe_user_entity_id integer,sohe_status varchar )
		returning id
	)
	select id into header_id from orderId;
	
	insert into sales.sales_order_detail (
		sode_qty,
        sode_unit_price,
        sode_unit_discount,
        sode_line_total,
        sode_sohe_id,
        sode_prog_entity_id
	)
	SELECT
        (item ->> 'qty')::INTEGER,
        (item ->> 'unit_price')::INTEGER,
        (item ->> 'unit_discount')::INTEGER,
        (item ->> 'line_total')::INTEGER,
        header_id,
        (item ->> 'prog_entity_id')::INTEGER
    FROM json_to_recordset(data) AS x(item);
    -- Commit the transaction
    COMMIT;
END
$BODY$;

drop procedure sales.insertsalesorders

