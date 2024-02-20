
create application role if not exists app_public;
create schema if not exists core;
grant usage on schema core to application role app_public;


create or replace function core.addtwo(i int)
returns int
language python
runtime_version = '3.8'
handler = 'addone_py'
as
$$
def addone_py(i):
  return i+2
$$;
grant usage on function core.addtwo(int) to application role app_public;

create or replace function core.addthree(i int)
returns int
language python
runtime_version = '3.8'
handler = 'addone_py'
as
$$
def addone_py(i):
  return i+3
$$;
grant usage on function core.addthree(int) to application role app_public;


create or replace procedure core.insertdata(num integer ,name varchar,org varchar)
returns varchar
language python
runtime_version = '3.8'
PACKAGES = ('snowflake-snowpark-python')
handler = 'run'
as
$$
def run(session,num,name,org):
  import pandas as pd
  df = session.sql(f"""Insert into app_data.accounts values ({num},'{name}','{org}');""").collect()
  return df
$$;
grant usage on procedure core.insertdata(integer,varchar,varchar) to application role app_public;


create table if not exists app_data.accounts
as (
Select 1 as "id", 'Ramesh' as "name", 'snowflake'as "value" union all
Select 2 as "id", 'Steve' as "name", 'snowflake'as "value" union all
Select 3 as "id", 'Bryan' as "name", 'snowflake'as "value" union all
Select 4 as "id", 'Steven' as "name", 'acme'as "value"
);

grant usage on schema app_data to application role app_public;
grant select on table app_data.accounts to application role app_public;






