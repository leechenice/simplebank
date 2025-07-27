installmigrate:
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

installsqlc:
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

postgres:
	docker run --name postgres17 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:17-alpine

createdb:
	docker exec -it postgres17 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres17 dropdb simple_bank

postgresURL="postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable"

migrateup:
	 migrate -path db/migration -database ${postgresURL} -verbose up

migratedown:
	migrate -path db/migration -database ${postgresURL} -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY:installmigrate installsqlc postgres createdb dropdb migrateup migratedown sqlc test