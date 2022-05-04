# ddi-mc3

 Datenbankdesign und Implementierung - SQL vs NoSQL

## NoSQL: TimescaleDB & SQL: Postgres

Start DB:
`docker-compose up`

Connect to the Container with psql:
`docker exec -it dbpostgres-ddi psql postgres://root:eVEdTBmhxODvYbBoCAlK@dbpostgres:5432/smartclassroom_ddl`
or
`docker exec -it dbtimescale-ddi psql postgres://root:eVEdTBmhxODvYbBoCAlK@dbtimescale:5432/smartclassroom_ddl`


DDL deffered from Django migration using:
`python manage.py sqlmigrate api 0001 > ddl.sql`
