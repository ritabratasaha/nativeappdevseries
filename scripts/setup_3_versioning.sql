
-- ADDITION TO SECURE DATA SHARING

-- WE ARE GOING TO UPGRADE THE PREVIOUS APP

    -- WE WILL SHARE DATA CONTENT HOSTED WITHIN THE APPLICATION. THIS DATA WILL BE AVAILABLE FOR USE BY THE APPLICATION LOGIC BUT NOT VISIBLE TO THE CONSUMER
    
-- APPLICATION VERSIONING

    -- ADD A VERSION NUMBER
    -- ADD A PATCH
    -- PERFORM UPGRADING
    

create application role app_public;
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


----- CREATE A TABLE WITHIN THE APPLICATION SETUP SCRIPT AND SHARE WITH CONSUMER


create schema if not exists app_shared_data;
create table if not exists app_shared_data.accounts_tbl_created_frm_setup(id int, name varchar, value varchar);
insert into app_shared_data.accounts_tbl_created_frm_setup values
  (1, 'Ramesh', 'snowflake'),
  (2, 'Steve', 'snowflake'),
  (3, 'Bryan', 'snowflake'),
  (4, 'Steven', 'acme');

grant usage on schema app_shared_data to application role app_public;


---- HERE IS THE CHANGE. I AM COMMENTING THIS PERMISSION SO THAT THE CONSUMER CANT VIEW THE DATA

---- grant select on table app_shared_data.accounts_tbl_created_frm_setup to application role app_public;


----- READ DATA FROM THE TABLE CREATED ABOVE

create or replace procedure core.read_data()
returns string
language python
runtime_version = '3.8'
packages = ('snowflake-snowpark-python','pandas')
handler = 'run'
execute as owner
as
$$
import pandas as pd
def run(session):  
    stmt = f"select current_database() current_database;"
    df = session.sql(stmt).to_pandas()
    database = df.iloc[0][0]
    schema = 'app_shared_data'

    df = session.sql(f"""select id,name,value from  {database}.app_shared_data.accounts_tbl_created_frm_setup""").collect()
    return df
    
$$;

grant usage on procedure core.read_data() to application role app_public;


