
-- THIS IS YOUR VERY FIRST NATIVE APP WITH A BASIC STORED PROCEDURE
-- WE WILL CREATE THIS APP USING THE SNOWSIGHT UI

create application role app_public;
create schema if not exists core;
grant usage on schema core to application role app_public;

create or replace procedure core.hello()
  returns string
  language sql
  execute as owner
  as
  begin
    return 'hello snowflake!';
  end;

grant usage on procedure core.hello() to application role app_public;

