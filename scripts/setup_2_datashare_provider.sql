

-- ALL ABOUT SECURE DATA SHARING - PROVIDER PERSPECTIVE

-- WE ARE GOING TO UPGRADE THE PREVIOUS APP

    -- WE WILL ADD A PYTHON STORED PROCEDURE
    -- WE WILL SHARE DATA CONTENT HOSTED WITHIN THE APPLICATION [3]
    -- WE WILL SHARE DATA CONTENT HOSTED WITHIN THE APPLICATION PACKAGE INTO THE APPLICATION [1]
    -- WE WILL SHARE DATA CONTENT FROM ANOTHER DATABASE (OUTSIDE THE APPLICATION PACKAGE) INTO THE APPLICATION [2]



create application role app_public;
create schema if not exists core;
grant usage on schema core to application role app_public;


create or replace function core.addtwo(i int)
returns int
language python
runtime_version = '3.8'
handler = 'addone_py'
AS
$$
def addone_py(i):
  return i+2
$$;

grant usage on function core.addtwo(int) to application role app_public;


----- CREATE A TABLE WITHIN THE APPLICATON SETUP SCRIPT AND SHARE WITH CONSUMER


create schema if not exists app_shared_data;
create table if not exists app_shared_data.accounts_tbl_created_frm_setup(id int, name varchar, value varchar);
insert into app_shared_data.accounts_tbl_created_frm_setup values
  (1, 'Ramesh', 'snowflake'),
  (2, 'Steve', 'snowflake'),
  (3, 'Bryan', 'snowflake'),
  (4, 'Steven', 'acme');

grant usage on schema app_shared_data to application role app_public;
grant select on table app_shared_data.accounts_tbl_created_frm_setup to application role app_public;



----- CREATE A VIEW FROM A TABLE STORED WITHIN THE APPLICATION PACKAGE AND SHARE WITHIN THE APPLICATION


create view if not exists app_shared_data.accounts_view_created_frm_pkg
as select id, name, value
from app_development_pkg.shared_content.accounts;

grant select on view app_shared_data.accounts_view_created_frm_pkg to application role app_public;


------ CREATE A VIEW FROM ANOTHER DATABASE WITHIN THE APPLICATION PACKAGE AND SHARE WITHIN THE APPLICATION

create view if not exists app_shared_data.customer_view_created_frm_pkg
as select c_name, c_phone
from app_development_pkg.shared_content.customer_view_created_frm_demo_db;

grant select on view app_shared_data.customer_view_created_frm_pkg to application role app_public;

----

