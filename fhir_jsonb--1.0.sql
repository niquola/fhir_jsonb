-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION fhir_jsonb" to load this file. \quit


CREATE TABLE test_jsonb (id SERIAL PRIMARY KEY);
