


use role accountadmin;

create role nativeappdeveloper;

grant create application package on account to role nativeappdeveloper;

grant create application on account to role nativeappdeveloper;

use role nativeappdeveloper;

create warehouse if not exists nativeappwh;

drop application package if exists app_development_pkg;

create application package app_development_pkg;

use application package app_development_pkg;
  
show stages;

ls @stage_content.app_stage;


--- Create the application from the package

drop application if exists our_first_app;

create application our_first_app
from application package app_development_pkg
using '@app_development_pkg.stage_content.app_stage';


--- Test the app

Call our_first_app.core.hello();
