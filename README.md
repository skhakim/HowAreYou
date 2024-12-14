### To Connect to the database in Docker

````bash
    psql -h localhost -p 5433 -U postgres -d mhst
````

### Back Up Data From Docker Container 
````bash
#Get postgres volume ID
docker ps

#create backup ( container must be running )
docker exec <id> pg_dump -U postgres mhst > backup.sql
````

### Write Data To Docker Container
````bash
cat backup.sql | docker exec -i <id> psql -U postgres
````