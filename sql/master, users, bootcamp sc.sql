
create table users.roles (
	role_id serial primary key,
	role_name varchar(35) unique not null,
	role_type varchar(15) not null,
	role_modified_date timestamptz default now()
)

ALTER TABLE users.users 
ADD COLUMN user_name varchar(15) UNIQUE,
ADD COLUMN user_password varchar(256),
ADD COLUMN user_firstname varchar(50),
ADD COLUMN user_lastname varchar(50),
ADD COLUMN user_birth_date date,
ADD COLUMN user_email_promotion int DEFAULT 0,
ADD COLUMN user_demographic json,
ADD COLUMN user_modified_date timestamptz,
ADD COLUMN user_photo varchar(255),
ADD COLUMN user_current_role int;


alter table users.users
add constraint fk_business_entity
foreign key(user_entity_id)
references users.business_entity(entity_id);

create table users.users_roles(
	usro_entity_id serial unique,
	usro_role_id serial unique,
	usro_modified_date timestamptz,
	primary key(usro_entity_id,usro_role_id)
)

alter table users.users
add constraint fk_user_current_role
foreign key(user_current_role)
references users.users_roles(usro_role_id)

alter table users.users_roles
add constraint fk_usro_entity_id
foreign key (usro_entity_id)
references users.users(user_entity_id)

alter table users.users_roles
add constraint fk_usro_role_id
foreign key (usro_role_id)
references users.roles(role_id)

create table users.users_media(
	usme_id serial,
	usme_entity_id int unique,
	usme_file_link varchar(255),
	usme_filename varchar(255),
	usme_filesize int,
	usme_filetype varchar(15) check (usme_filetype in ('jpg','pdf','word')),
	usme_note varchar(55),
	usme_modified_date timestamptz,
	primary key(usme_id,usme_entity_id)
)

alter table users.users_media add constraint fk_usme_entity_id 
foreign key (usme_entity_id)
references users.users(user_entity_id);

create table users.users_license(
	usli_id serial,
	usli_license_code varchar(512) unique,
	usli_modified_date timestamptz,
	usli_status varchar(15) check (usli_status in ('Active','NonActive')),
	usli_entity_id int,
	primary key (usli_id,usli_entity_id)
)

alter table users.users_license add constraint fk_usli_entity_id
foreign key (usli_entity_id) references users.users(user_entity_id)

create table users.users_email(
	pmail_entity_id int unique,
	pmail_id serial,
	pmail_address varchar(50),
	pmail_modified_date timestamptz,
	primary key (pmail_entity_id,pmail_id)
)

alter table users.users_email add constraint fk_pmail_entity_id
foreign key (pmail_entity_id) references users.users(user_entity_id)

create table users.users_education(
	usdu_id serial,
	usdu_entity_id int unique,
	usdu_scholl varchar(255),
	usdu_degree varchar(15) check (usdu_degree in ('Bachelor','Diploma')),
	usdu_field_study varchar(125),
	usdu_graduate_year varchar(4),
	usdu_start_date timestamptz,
	usdu_start_end timestamptz,
	usdu_grade varchar(5),
	usdu_activities varchar(512),
	usdu_description varchar(512),
	usdu_modified_date timestamptz,
	primary key (usdu_id,usdu_entity_id)
)

alter table users.users_education add constraint fk_usdu_entity_id
foreign key (usdu_entity_id) references users.users(user_entity_id)

create table users.phone_number_type (
	ponty_code varchar(15) primary key,
	ponty_modified_date timestamptz
)

create table users.users_phones (
	uspo_entity_id int unique,
	uspo_number varchar(15),
	uspo_modified_date timestamptz,
	uspo_ponty_code varchar(15),
	primary key (uspo_entity_id,uspo_number)
)

alter table users.users_phones add constraint fk_uspo_ponty_code
foreign key (uspo_ponty_code) references users.phone_number_type(ponty_code)

alter table users.users_phones add constraint fk_uspo_entity_id
foreign key (uspo_entity_id) references users.users(user_entity_id)

create table users.users_address(
	etad_addr_id int primary key,
	etad_modified_date timestamptz,
	etad_entity_id int,
	etad_adty_id int
)

alter table users.users_address add constraint fk_etad_entity_id
foreign key (etad_entity_id) references users.users(user_entity_id)

--jalankan ketika ada schema master
alter table users.users_address add constraint fk_etad_addr_id
foreign key (etad_addr_id) references master.address(addr_id)
alter table users.users_address add constraint fk_etad_adty_id
foreign key (etad_adty_id) references master.address_type(adty_id)

create table users.users_skill(
	uski_id serial,
	uski_entity_id int,
	uski_modified_date timestamptz,
	uski_skty_name varchar(15) unique,
	primary key (uski_id,uski_entity_id)
)

alter table users.users_skill add constraint fk_uski_entity_id
foreign key (uski_entity_id) references  users.users(user_entity_id)

--jalankan ketika ada schema master
alter table users.users_skill add constraint fk_uski_skty_name
foreign key (uski_skty_name) references master.skill_type(skty_name)

create table users.users_experiences(
	usex_id serial,
	usex_entity_id int unique,
	usex_title varchar(255),
	usex_profile_headline varchar(512),
	usex_employment_type varchar(15) check (usex_employment_type in ('fulltime','freelance')),
	usex_company_name varchar(255),
	usex_city_id int,
	usex_is_current char(1) check (usex_is_current in ('0','1')),
	usex_start_date timestamptz,
	usex_end_date timestamptz,
	usex_industry varchar(15),
	usex_description varchar(512),
	usex_experience_type varchar(15) check (usex_experience_type in ('company','certfied','voluntering','organization','reward')),
	primary key(usex_id,usex_entity_id)
)

alter table users.users_experiences add constraint fk_usex_entity_id
foreign key (usex_id) references users.users(user_entity_id)

create table users.users_experiences_skill(
	uesk_usex_id int ,
	uesk_uski_id int ,
	primary key(uesk_usex_id,uesk_uski_id)
)

alter table users.users_skill add constraint uski_id_key unique(uski_id)
alter table users.users_experiences add constraint usex_id_key unique(usex_id)

alter table users.users_experiences_skill add constraint uesk_usex_id
foreign key (uesk_usex_id) references users.users_experiences(usex_id)

alter table users.users_experiences_skill add constraint uesk_uski_id
foreign key (uesk_uski_id) references users.users_skill(uski_id)

alter table master.province add constraint prov_country_code foreign key (prov_country_code) references master.country(country_code)
alter table master.address add constraint addr_city_id foreign key (addr_city_id)references master.city(city_id)