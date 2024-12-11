#!/bin/bash
set -e

function create_user_and_database() {
	local db=$1
	local dbuser="$2"
	local dbpassword="$3"
	echo "  Creating user and database '$db' with DB user: $dbuser"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
		CREATE USER $dbuser;
		ALTER USER $dbuser with encrypted password '$dbpassword';
		ALTER USER $dbuser CREATEDB;
		CREATE DATABASE $db;
		GRANT CREATE ON SCHEMA public TO $dbuser;
		GRANT USAGE ON SCHEMA public TO $dbuser;
		GRANT ALL PRIVILEGES ON DATABASE $db TO $dbuser;
EOSQL
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$db" -c "GRANT ALL ON SCHEMA public TO $dbuser;"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$db" -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $dbuser;"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$db" -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $dbuser;"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$db" -c "GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $dbuser;"
}

function update_database_with_postgis() {
    local db=$1
    echo "  Updating databse '$db' with extension"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db" <<-EOSQL
		CREATE EXTENSION IF NOT EXISTS postgis;
		GRANT ALL ON geometry_columns TO PUBLIC;
		GRANT ALL ON spatial_ref_sys TO PUBLIC;
EOSQL
}

if [ -n "$AIRFLOW_DATABASE" ]; then
	echo "Airflow database creation requested: $AIRFLOW_DATABASE"
	create_user_and_database $AIRFLOW_DATABASE "$AIRFLOW_DATABASE_USER" "$AIRFLOW_DATABASE_PASSWORD"
	# update_database_with_postgis $AIRFLOW_DATABASE "$AIRFLOW_DATABASE_USER" "$AIRFLOW_DATABASE_PASSWORD"
	echo "Airflow database created"
fi
