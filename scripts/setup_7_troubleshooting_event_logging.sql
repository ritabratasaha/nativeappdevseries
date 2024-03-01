-- Setup script for the Snowflake! application to demostrate event logging and sharing

CREATE APPLICATION ROLE APP_PUBLIC;
CREATE SCHEMA IF NOT EXISTS CORE;
GRANT USAGE ON SCHEMA CORE TO APPLICATION ROLE APP_PUBLIC;



create or replace stage CORE.MODEL_STAGE
	directory = ( enable = true )
    comment = 'used for holding ML Models.';

GRANT READ ON STAGE CORE.MODEL_STAGE TO APPLICATION ROLE APP_PUBLIC;
GRANT WRITE ON STAGE CORE.MODEL_STAGE TO APPLICATION ROLE APP_PUBLIC;
--


CREATE OR REPLACE FUNCTION CORE.log_trace_data()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.8
HANDLER = 'run'
AS $$
import logging
logger = logging.getLogger("tutorial_logger_consumer")
logger.setLevel(logging.INFO)
def run():
  logger.info("Logging from Python function.")
  return "SUCCESS"
$$;


GRANT USAGE ON function CORE.log_trace_data() TO APPLICATION ROLE APP_PUBLIC;
-- -- 
