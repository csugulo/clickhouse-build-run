.PHONY: config
config:
	rm -rf clickhouse01 clickhouse02 clickhouse03 clickhouse04
	mkdir -p clickhouse01 clickhouse02 clickhouse03 clickhouse04
	REPLICA=01 SHARD=01 envsubst < docker-cluster-config.xml > clickhouse01/config.xml
	REPLICA=02 SHARD=02 envsubst < docker-cluster-config.xml > clickhouse02/config.xml
	REPLICA=03 SHARD=03 envsubst < docker-cluster-config.xml > clickhouse03/config.xml
	REPLICA=04 SHARD=04 envsubst < docker-cluster-config.xml > clickhouse04/config.xml
	cp users.xml clickhouse01/users.xml
	cp users.xml clickhouse02/users.xml
	cp users.xml clickhouse03/users.xml
	cp users.xml clickhouse04/users.xml

.PHONY: config-local
config-local:
	rm -rf clickhouse
	mkdir -p clickhouse
	DB_DIR=$(CURDIR)/clickhouse envsubst < local-config.xml > clickhouse/config.xml
	cp users.xml clickhouse/users.xml

.PHONY: up
up:
	docker-compose up -d

.PHONY: start
start:
	docker-compose start

.PHONY: stop
down:
	docker-compose stop

.PHONY: restart
down:
	docker-compose restart

.PHONY: down
down:
	docker-compose down
