# MQTT Broker With Authentication Plugin

This repository contains Mosquitto Mqtt Server togather with Mosquitto-Go-Auth plugin, combined in a way it can be quickly built and deployed by running docker compose in root directory.

https://github.com/iegomez/mosquitto-go-auth
https://github.com/eclipse/mosquitto

This project is configured to use HTTP backend for Client Auth, but Mosquitto-Go-Auth plugin can do much more. Go and check it out at the link above.


## Files

Edit mosquitto.conf file in root directory, update it with your HTTP server detail and needed authentication endpoints.

## Create and run Docker instance

 1. If you do not have docker-compose get it at:
    https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
 2. Run docker-compose up --build to build and run the docker container
 3. Next time you can run it with docker-compose up -d to run docker container detached

## Example HTTP Auth Back-end

    
