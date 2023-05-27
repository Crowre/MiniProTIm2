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
	prog_status varchar(15)
)

create table curriculum.program_reviews(
	prow_user_entity_id int,
	prow_prog_entity_id int,
	prow_review varchar(512),
	prow_rating int,
	prow_modified_date timestamptz,
	foreign key (prow_prog_entity_id) references curriculum.program_entity(prog_entity_id)
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
	sect_id serial primary key,
	sect_prog_entity_id int,
	sect_title varchar(100),
	sect_decription varchar(256),
	sect_total_section int,
	sect_total_lecture int,
	sect_total_minute int,
	foreign key(sect_prog_entity_id) references curriculum.program_entity(prog_entity_id)
)

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

create table curriculum.section_detail_material(
	sedm_ serial primary key,
	sedm_filename varchar(55),
	sedm_filesize int,
	sedm_filelink varchar(256),
	sedm_modified_date timestamptz,
	sedm_secd_id int,
	foreign key(sedm_secd_id)references curriculum.section_detail(secd_id)
)




