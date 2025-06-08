terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Create a Docker network for communication between containers
resource "docker_network" "app_network" {
  name = "app_network"
}

# Pull MariaDB image (lighter MySQL alternative)
resource "docker_image" "mysql" {
  name = "mariadb:10.5.8-focal"
}

# Create MariaDB container
resource "docker_container" "mysql" {
  name  = "mysql_db"
  image = docker_image.mysql.name

  env = [
    "MYSQL_ROOT_PASSWORD=root",
    "MYSQL_DATABASE=mydb",
    "MYSQL_USER=user",
    "MYSQL_PASSWORD=pass"
  ]

  ports {
    internal = 3306
    external = 3306
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "always"
}

# Build PHP web app image from local ./web folder
resource "docker_image" "web" {
  name = "simple-web"
  build {
    context = "${path.module}/web"
  }
}

# Create web app container
resource "docker_container" "web" {
  name  = "web_app"
  image = docker_image.web.name

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  depends_on = [docker_container.mysql]

  restart = "always"
}
