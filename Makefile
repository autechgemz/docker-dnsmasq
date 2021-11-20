all: build
build:
	docker build -t autechgemz/dnsmasq .
full:
	docker build --no-cache -t autechgemz/dnsmasq .
push:
	docker push autechgemz/dnsmasq
clean:
	docker-compose down -v
	docker rm -f -v dnsmasq
distclean:
	docker-compose down -v
	docker rmi -f autechgemz/dnsmasq
