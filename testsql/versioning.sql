

----- Lets add a version and patch

USE APPLICATION PACKAGE app_development_pkg;

ALTER APPLICATION PACKAGE app_development_pkg ADD VERSION V1 USING @stage_content.app_stage;

ALTER APPLICATION PACKAGE app_development_pkg ADD PATCH FOR VERSION V1 USING @app_development_pkg.stage_content.app_stage;

CREATE APPLICATION  our_first_app FROM APPLICATION PACKAGE app_development_pkg USING VERSION V1 patch 2;

SHOW APPLICATIONS;


------ Create the application from the package

drop application if exists our_first_app;

create application our_first_app
from application package app_development_pkg
using '@app_development_pkg.stage_content.app_stage';