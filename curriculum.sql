create table hr.employee(
	emp_entity_id int primary key
)

create table users.city (
	city_id serial primary key
)

create table master.category(
	cate_id serial primary key
)

create table master.status(
	status varchar(15) primary key
)

create type prog_type_status as enum('bootcamp','course')
alter table curriculum.program_entity alter column prog_type type prog_type_status 
using prog_type::prog_type_status

create type prog_learning_status as enum('online','offline','both')
alter table curriculum.program_entity alter column prog_learning_type type prog_learning_status 
using prog_learning_type::prog_learning_status

create type prog_best_seller_status as enum ('0','1')
alter table curriculum.program_entity alter column prog_best_seller type prog_best_seller_status 
using prog_best_seller::prog_best_seller_status

create type prog_language_status as enum ('english','bahasa')
alter table curriculum.program_entity alter column prog_language type prog_language_status 
using prog_language::prog_language_status

create type prog_duration_type_status as enum ('month', 'week', 'days')
alter table curriculum.program_entity alter column prog_duration_type type prog_duration_type_status 
using prog_duration_type::prog_duration_type_status

create table curriculum.program_entity(
	prog_entity_id serial primary key,
	prog_title varchar(256),
	prog_headline varchar (512),
	prog_type varchar(15),
	prog_learning_type varchar(15),
	prog_rating numeric,
	prog_total_trainee int,
	prog_modified_date timestamptz,
	prog_image varchar(256),
	prog_best_seller char(1),
	prog_price numeric,
	prog_language varchar(35),
	prog_duration int,
	prog_duration_type varchar(15),
	prog_tag_skill varchar(512),
	
	prog_city_entity_id int,
	prog_cate_id int,
	prog_create_by int,
	prog_status varchar(15),
	
	foreign key(prog_city_entity_id) references users.city(city_id),
	foreign key(prog_cate_id) references master.category(cate_id),
	foreign key(prog_create_by) references hr.employee(emp_entity_id),
	foreign key(prog_status) references master.status(status)
)

create table curriculum.program_reviews(
	prow_user_entity_id int,
	prow_prog_entity_id int,
	prow_review varchar(512),
	prow_rating int,
	prow_modified_date timestamptz,
	primary key(prow_prog_entity_id, prow_user_entity_id),
	foreign key (prow_prog_entity_id) references curriculum.program_entity(prog_entity_id),
	foreign key (prow_user_entity_id) references users.users(user_entity_id)
)

create table curriculum.program_entity_decription(
	pred_entity_id int primary key,
	pred_item_learning json,
	pred_item_include json,
	pred_requirement json,
	pred_description json,
	pred_target_level json,
	foreign key(pred_entity_id) references curriculum.program_entity(prog_entity_id)
)

create table curriculum.section(
	sect_id serial,
	sect_prog_entity_id int,
	sect_title varchar(100),
	sect_decription varchar(256),
	sect_total_section int,
	sect_total_lecture int,
	sect_total_minute int,
	primary key(sect_id, sect_prog_entity_id),
	foreign key(sect_prog_entity_id) references curriculum.program_entity(prog_entity_id)
)

create type secd_preview_status as enum ('0','1')
alter table curriculum.section_detail alter column secd_preview type secd_preview_status
using secd_preview::secd_preview_status

alter table curriculum.section add constraint sect_unique_id unique(sect_id) 

create table curriculum.section_detail(
	secd_id serial primary key,
	secd_title varchar(256),
	secd_preview char(1),
	secd_score int,
	secd_note varchar(256),
	secd_minute int,
	secd_modified_date timestamptz,
	secd_sect_id int,
	foreign key(secd_sect_id)references curriculum.section(sect_id)
)

create type sedm_filetype_status as enum('video','image','text','link')
alter table curriculum.section_detail_material alter column sedm_filetype type sedm_filetype_status
using sedm_filetype::sedm_filetype_status



create table curriculum.section_detail_material(
	sedm_ serial primary key,
	sedm_filename varchar(55),
	sedm_filesize int,
	sedm_filetype varchar(15),
	sedm_filelink varchar(256),
	sedm_modified_date timestamptz,
	sedm_secd_id int,
	foreign key(sedm_secd_id)references curriculum.section_detail(secd_id)
)




