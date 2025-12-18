use subway;

CREATE TABLE subway_flow (
  usage_month INT,
  line VARCHAR(10),
  station VARCHAR(50),
  hour INT,
  on_cnt INT,
  off_cnt INT
);

describe subway_flow;
select count(*) from subway_flow;

select
	station,
    sum(case when hour = 8 then off_cnt else 0 end) as morning_off ,
    sum(case when hour = 18 then on_cnt else 0 end) as evening_on
from subway_flow
group by station;

create view commute_summary as
select
	station,
    sum(case when hour = 8 then off_cnt else 0 end) as morning_off,
    sum(case when hour = 18 then on_cnt else 0 end) as evening_on
from subway_flow
group by station;

select *
from commute_summary
where evening_on = 0;

select 
	station,
    morning_off,
    evening_on,
    morning_off/evening_on as commute_index
from commute_summary
order by commute_index desc;


