#!/bin/bash -eu

echo "preparing for the database."

psql -U root -f /init_files/sql/01_setup.sql
psql -U root -d sampledb -f /init_files/sql/02_create_tables.sql

echo "finished setting up the database."
