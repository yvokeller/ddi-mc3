# ddi-mc3
 Datenbankdesign und Implementierung - SQL vs NoSQL

## Structure
```
|   Bericht.url                             # URL to the Report
|   docker-compose.yaml                     # Docker Compose Configuration File
+---Comparison
|       postgres-Histogram.sql              # Postgres Histogram Comparison SQL File
|       postgres-timebucket.sql             # Postgres Timebucket Comparison SQL File
|       postgres-TimeOrdering.sql           # Postgres TimeOrdering Comparison SQL File
|       postgres-vs-timescaledb.sql         # Collection of Comparisons / Ignore this
|       timescale-Histogram.sql             # Timescale Histogram Comparison SQL File
|       timescale-timebucket.sql            # Timescale Timebucket Comparison SQL File
|       timescale-TimeOrdering.sql          # Timescale TimeOrdering Comparison SQL File
|
+---DatabaseScripts
|   |   2_dml.sql                           # SQL Script for Random Generation of Data
|   |
|   +---NoSQL
|   |       1_ddl.sql                       # SQL Script for Database Creation for Timescale DB
|   |
|   \---SQL
|           1_ddl.sql                       # SQL Script for Database Creation for PostgreSQL DB
|
+---Modelle
|   +---ERD
|   |       ERM_ERD_DDI_LE2.drawio          
|   |       ERM_ERD_DDI_LE2.png             # ERD Model of Datastructure
|   |
|   \---UML
|           UML_RelModel_DDI_LE2.drawio
|           UML_RelModel_DDI_LE2.png        # UML Model of Datastructure
```




## Docker: TimescaleDB & SQL
### Prerequisites for Docker
- https://docs.docker.com/compose/install/
- https://docs.docker.com/compose/gettingstarted/

If you don't want to use docker, all the SQL Files are described in the Structure Section.

### Starting the Docker Containers
To start the docker containers:
- `cd` into the main repository directory
- execute `docker-compose up` in a terminal

### SQL Connection Information from Docker 
- Server=localhost
- Port=5432
- User=root
- Pw=eVEdTBmhxODvYbBoCAlK

### Connect to the Docker Containers

Connect to the Postgres Container with psql:
```
docker exec -it dbpostgres-ddi psql postgres://root:eVEdTBmhxODvYbBoCAlK@dbpostgres:5432/smartclassroom_ddl
```
or Timescale Container with psql:
```
docker exec -it dbtimescale-ddi psql postgres://root:eVEdTBmhxODvYbBoCAlK@dbtimescale:5432/smartclassroom_ddl
```
or with a Management Software:
- Datagrip
- Pgadmin
- ....

## Other
DDL deffered from Django migration using:
`python manage.py sqlmigrate api 0001 > ddl.sql`
