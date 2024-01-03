.PHONY: build run restart stop rm delete test sh create-repo delete-repo upload_image push

APP_NAME ?= seba1
GH_USER ?= sebastiavillalobos
VISIBILITY ?= private
VERSION ?= 0.0.1


# Build the Docker image
build:
	@docker build -t seba1 .

# Run the Docker container
run: build
	@echo "Init Container on localhost:8282"
	@docker run -d -p 8282:8282 --name seba1 seba1

# Stop the running Docker container
stop:
	@echo "Stoping seba1 container"
	@docker ps -q --filter "name=seba1" | grep -q . && docker stop seba1 || true

# Remove the stopped container
rm:
	@echo "Removing seba1 container"
	@docker ps -a -q --filter "name=seba1" | grep -q . && docker rm seba1 || true

# Restart the Docker container
restart: stop rm build run

# Delete the project directory
delete: stop rm
	@echo "Deleting seba1 project"
	@cd ..
	@rm -rf seba1

# Run test script
test:
	@echo "Running script test_script.sh"
	@.\/test_script.sh
	@cd ..

# Upload Docker image to Docker Hub
upload_image: build
	@docker buildx build --platform linux\/amd64 -t seba1-amd64: .
	@docker tag seba1-amd64: sebiuo\/seba1:
	@docker push sebiuo\/seba1:
	@cd ..

# Run sh in container
sh:
	@docker exec -it seba1 sh

# Create a new repository
create-repo:
	@echo "Creating a new repository seba1..."
	@gh repo create sebastiavillalobos\/seba1 --public --description "seba1 project repository"
	@git init
	@git add .
	@git commit -m "Initial commit for seba1 project"
	@git branch -M main
	@git remote add origin https:\/\/github.com\/sebastiavillalobos\/seba1.git
	@git push -u origin main

# Delete repository
delete-repo:
	@echo "Deleting repository seba1..."
	@gh repo delete sebastiavillalobos\/seba1 --confirm

# Push changes to repository
push:
	@git add .
	@git commit -m "Update seba1 project"
	@git push -u origin main
