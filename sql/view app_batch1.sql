select batch_name, batch_description as tech, batch_start_date, batch_end_date, batch_status 
from bootcamp.batch

select batch_name, prog_entity_id as tech, batch_start_date, batch_end_date,
batch_status
from bootcamp.batch join curriculum.program_entity 
on bootcamp.batch.batch_entity_id = curriculum.program_entity.prog_entity_id
--prog_entity_id ganti ke prog_title



select batch_name,prog_entity_id as tech, batr_id as members,batch_start_date, batch_end_date,
batch_status
from bootcamp.batch 
join curriculum.program_entity on bootcamp.batch.batch_entity_id = curriculum.program_entity.prog_entity_id
join bootcamp.batch_trainee on bootcamp.batch.batch_id = bootcamp.batch_trainee.batr_batch_id
--count membernya di back-end

