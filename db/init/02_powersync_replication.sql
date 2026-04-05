-- Create replication role for PowerSync
CREATE ROLE powersync_role WITH REPLICATION LOGIN PASSWORD 'powersync_password';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO powersync_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO powersync_role;

-- Create schema for PowerSync internal bucket storage
CREATE SCHEMA IF NOT EXISTS powersync;
GRANT ALL ON SCHEMA powersync TO "user";
GRANT ALL ON ALL TABLES IN SCHEMA powersync TO "user";
ALTER DEFAULT PRIVILEGES IN SCHEMA powersync GRANT ALL ON TABLES TO "user";

-- Publication for all tables (tables created later by Drizzle migrations)
-- PowerSync sync streams control which data actually gets synced
CREATE PUBLICATION powersync FOR ALL TABLES;
