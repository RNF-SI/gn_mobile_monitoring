CREATE EXTENSION IF NOT EXISTS "hstore";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "unaccent";
CREATE EXTENSION IF NOT EXISTS "ltree";



CREATE EXTENSION IF NOT EXISTS "postgis";
-- postgis_raster must be installed separatly only on recent versions of postgis
DO
$$
BEGIN
    IF EXISTS (
        SELECT name FROM PG_CATALOG.PG_AVAILABLE_EXTENSIONS WHERE name = 'postgis_raster'
    ) THEN
        CREATE EXTENSION IF NOT EXISTS "postgis_raster";
    END IF;
END
$$
