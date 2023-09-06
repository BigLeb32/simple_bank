postgres:
	@echo "Starting postgres..."
	docker run --name postgres15 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

createdb:
	@echo "Creating database..."
	docker exec -it postgres15  createdb --username=root --owner=root simple_bank

dropdb:
	@echo "Dropping database..."
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	@echo "Migrating up..."
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up

migratedown:
	@echo "Migrating down..."
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down

sqlc:
	@echo "Generating sqlc..."
	sqlc generate

test:
	@echo "Testing..."
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc