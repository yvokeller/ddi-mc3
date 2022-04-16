# ddi-mc3

 Datenbankdesign und Implementierung - SQL vs NoSQL

## NoSQL: TimescaleDB

Start DB:
`docker run -p 5433:5432 --name timescale-local -e POSTGRES_PASSWORD=password timescale/timescaledb:latest-pg14`

DDL deffered from Django migration using:
`python manage.py sqlmigrate api 0001 > ddl.sql`
