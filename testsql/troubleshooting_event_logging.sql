----- PROVIDER SETUP -----

use role nativeappdeveloper;

SHOW EVENT TABLES;

Create database DEMO_DB_PROVIDER;

Use database DEMO_DB_PROVIDER;

CREATE EVENT TABLE DEMO_DB_PROVIDER.public.event_logging;

CREATE EVENT TABLE DEMO_DB_PROVIDER.public.event_logging_test;

use role accountadmin;

ALTER ACCOUNT SET EVENT_TABLE = DEMO_DB_PROVIDER.public.event_logging;

ALTER ACCOUNT UNSET EVENT_TABLE;

SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;


drop application package if exists app_development_pkg;

create application package app_development_pkg;

use application package app_development_pkg;

create schema if not exists stage_content;

create or replace stage app_development_pkg.stage_content.app_stage;
  
show stages;

ls @stage_content.app_stage;


--- Create the application from the package

drop application if exists our_first_app;

create application our_first_app
from application package app_development_pkg
using '@app_development_pkg.stage_content.app_stage';




--------SETUP PROVIDER TO RECEIVE EVENTS TRIGGERED IN THE REGION-------

use role accountadmin;

grant role orgadmin to user RITAB;

use role orgadmin;

show organization accounts;

Select current_region();

Select current_account();

CALL SYSTEM$SHOW_EVENT_SHARING_ACCOUNTS();

CALL SYSTEM$SET_EVENT_SHARING_ACCOUNT_FOR_REGION('AWS_US_WEST_2','PUBLIC','PSE_ISD_DCR1');


-------TEST LOCALLY INSTALLED APP------


-- Check if the Log_level =  INFO
DESC APPLICATION LOGG_APP;


SELECT LOGG_APP.core.log_trace_data();


Select * from DEMO_DB_PROVIDER.public.event_logging
where SCOPE['name'] = 'tutorial_logger_consumer';



----- CONSUMER SETUP ------


use role nativeappconsumer;


-- Check if the Log_level =  INFO
DESC APPLICATION LOGG_APP;

SELECT LOGG_APP.core.log_trace_data();

Select * from demo_db.public.event_logging where SCOPE['name'] = 'tutorial_logger_consumer';


-------- ENABLE CONSUMER SHARING


use role accountadmin;
SHOW EVENT TABLES;
Create database DEMO_DB;
Use database DEMO_DB;
CREATE EVENT TABLE DEMO_DB.public.event_logging;
ALTER ACCOUNT SET EVENT_TABLE = DEMO_DB.public.event_logging;

ALTER APPLICATION LOGG_APP  SET SHARE_EVENTS_WITH_PROVIDER = TRUE;

-------- DEBUG MODE

Desc application our_first_app;

ALTER APPLICATION our_first_app SET DEBUG_MODE = True;

SELECT distinct METADATA$FILENAME, METADATA$FILE_LAST_MODIFIED FROM @our_first_app.stage_content.app_stage;

SELECT BUILD_SCOPED_FILE_URL('@our_first_app.stage_content.app_stage','readme.md');



