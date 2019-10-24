run:
	docker-compose down
	docker-compose up
build_image:
	docker-compose build
clean_variables:
	rm -f .env
new_variables: clean_variables
	. ./install/environment.sh; getVariables
install: new_variables run
all: build_image install