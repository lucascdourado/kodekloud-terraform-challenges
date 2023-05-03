#Terraform resource named php-httpd-image
resource "docker_image" "php-httpd-image" {
  name = "php-httpd:challenge"
  build {
    path = "lamp_stack/php_httpd"
    tag  = ["php-httpd:challenge"]
    label = {
      challenge : "second"
    }
  }
}

#Terraform resource named mariadb-image
resource "docker_image" "mariadb-image" {
  name = "mariadb:challenge"
  build {
    path = "lamp_stack/custom_db"
    tag  = ["mariadb:challenge"]
    label = {
      challenge : "second"
    }
  }
}

#Terraform resource php-httpd for creating docker container
resource "docker_container" "php-httpd" {
  name     = "webserver"
  image    = docker_image.php-httpd-image.name
  hostname = "php-httpd"
  networks_advanced {
    name = docker_network.private_network.id
  }
  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
  }
  labels {
    label = "challenge"
    value = "second"
  }
  volumes {
    container_path = "/var/www/html"
    host_path      = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
  }
}

#Terraform resource phpmyadmin for docker container
resource "docker_container" "phpmyadmin" {
  name     = "db_dashboard"
  image    = "phpmyadmin/phpmyadmin"
  hostname = "phpmyadmin"
  networks_advanced {
    name = docker_network.private_network.id
  }
  ports {
    internal = "80"
    external = "8081"
    ip       = "0.0.0.0"
  }
  labels {
    label = "challenge"
    value = "second"
  }
  links = [
    docker_container.mariadb.name
  ]
  depends_on = [
    docker_container.mariadb
  ]
}

#Terraform resource named private_network
resource "docker_network" "private_network" {
  name       = "my_network"
  attachable = true
  labels {
    label = "challenge"
    value = "second"
  }
}

#Terraform resource mariadb for creating docker container
resource "docker_container" "mariadb" {
  name     = "db"
  image    = docker_image.mariadb-image.name
  hostname = "db"
  networks_advanced {
    name = docker_network.private_network.id
  }
  ports {
    internal = 3306
    external = 3306
    ip       = "0.0.0.0"
  }
  labels {
    label = "challenge"
    value = "second"
  }
  env = [
    "MYSQL_ROOT_PASSWORD=1234",
    "MYSQL_DATABASE=simple-website"
  ]
  volumes {
    container_path = "/var/lib/mysql"
    volume_name    = docker_volume.mariadb_volume.name
  }
}

#Terraform resource named mariadb_volume
resource "docker_volume" "mariadb_volume" {
  name = "mariadb-volume"
}