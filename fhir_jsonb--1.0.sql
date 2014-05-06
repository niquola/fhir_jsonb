-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION fhir_jsonb" to load this file. \quit

DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS encounters;
DROP TABLE IF EXISTS observations;

CREATE TABLE patients (
  id SERIAL primary key,
  doc jsonb
);

CREATE TABLE encounters (
  id SERIAL primary key,
  doc jsonb
);

CREATE TABLE observations (
  id SERIAL primary key,
  doc jsonb
);

insert into patients (doc)
select '{}'::jsonb
from generate_series(1, 100) n;

insert into encounters (doc)
select '{}'::jsonb
from generate_series(1, 1000) n;

insert into observations (doc)
select '{}'::jsonb
from generate_series(1, 10000) n;
