grant create application package on account to role nativeappdeveloper;

grant create application on account to role nativeappdeveloper;

use role nativeappdeveloper;

create database if not exists demo_db;

create warehouse if not exists nativeappwh;

drop application package if exists app_development_pkg;

create application package app_development_pkg;

use application package app_development_pkg;

create schema if not exists stage_content;

create schema if not exists shared_content;

create table if not exists shared_content.accounts (id int, name varchar, value varchar);

insert into shared_content.accounts values
  (1, 'nihar', 'snowflake'),
  (2, 'frank', 'snowflake'),
  (3, 'benoit', 'snowflake'),
  (4, 'steven', 'acme');

Grant usage on schema app_development_pkg.shared_content to share in application package app_development_pkg;
  
grant select on table app_development_pkg.shared_content.accounts to share in application package app_development_pkg;

create or replace stage app_development_pkg.stage_content.app_stage;
  
show stages;

ls @app_stage;


--- Create the application from the package

drop application if exists our_first_app;

create application our_first_app
from application package app_development_pkg
using '@app_development_pkg.stage_content.app_stage';


---- Create a view in the appllication package from the another database. This view needs to be shared as a part of the application


CREATE VIEW IF NOT EXISTS app_development_pkg.shared_content.customer_view_created_frm_demo_db
AS SELECT c_name, c_phone
FROM demo_db.public.customer_Data;

GRANT REFERENCE_USAGE ON DATABASE demo_db  TO SHARE IN APPLICATION PACKAGE app_development_pkg;

GRANT USAGE ON SCHEMA app_development_pkg.shared_content TO SHARE IN APPLICATION PACKAGE app_development_pkg;

GRANT SELECT ON VIEW app_development_pkg.shared_content.customer_view_created_frm_demo_db  TO SHARE IN APPLICATION PACKAGE app_development_pkg;




--- Test the app

Select our_first_app.core.addtwo(99);

Call our_first_app.core.read_data(); 

Call our_first_app.core.hello();

Select * from our_first_app.app_shared_data.accounts_view_created_frm_pkg;





