

-- ALL ABOUT SECURE DATA SHARING - CONSUMER PERSPECTIVE
  
  -- THE CONSUMER SHARES A DATASET WITH THE APPLICATION    


create application role app_public;
create schema if not exists core;
grant usage on schema core to application role app_public;

----- READ DATA FROM THE TABLE WHICH THE CONSUMER SHARES

CREATE OR REPLACE PROCEDURE core.read_data()
RETURNS TABLE()
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'
EXECUTE AS OWNER
AS
$$
import sys
import os
import logging
from datetime import datetime

def run(session):
    import pandas as pd
    df = session.sql(f"""Select * from reference('HOUSING_DATA')""")
    return df

$$;

grant usage on procedure core.read_data() to application role app_public;



create or replace procedure core.update_reference(ref_name string, operation string, ref_or_alias string)
returns string
language sql
as $$
begin
  case (operation)
    when 'ADD' then
       SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
    when 'REMOVE' then
       SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
    when 'CLEAR' then
       SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
    else
       return 'Unknown operation: ' || operation;
  end case;
  return 'Success';
end;
$$;

GRANT usage on procedure core.update_reference(string, string, string) to application role app_public;
