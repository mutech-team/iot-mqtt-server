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
### Simple Bottle Backend
Taken from https://github.com/jpmens/mosquitto-auth-plug
```python
__author__    = 'Jan-Piet Mens <jp@mens.de>'
__copyright__ = 'Copyright 2014 Jan-Piet Mens'

import sys
import bottle
from bottle import response, request

app = application = bottle.Bottle()

@app.route('/auth', method='POST')
def auth():
    response.content_type = 'text/plain'
    response.status = 403

    # data = bottle.request.body.read()   # username=jane%40mens.de&password=jolie&topic=&acc=-1

    username = request.forms.get('username')
    password = request.forms.get('password')
    topic    = request.forms.get('topic')
    acc      = request.forms.get('acc')

    if username == 'jane@mens.de' and password == 'jolie':
        response.status = 200

    return None

@app.route('/superuser', method='POST')
def superuser():
    response.content_type = 'text/plain'
    response.status = 403

    data = bottle.request.body.read()   # username=jane%40mens.de&password=&topic=&acc=-1

    username = request.forms.get('username')

    if username == 'special':
        response.status = 200

    return None


@app.route('/acl', method='POST')
def acl():
    response.content_type = 'text/plain'
    response.status = 403

    data = bottle.request.body.read()   # username=jane%40mens.de&password=&topic=t%2F1&acc=2&clientid=JANESUB

    username = request.forms.get('username')
    topic    = request.forms.get('topic')
    clientid = request.forms.get('clientid')
    acc      = request.forms.get('acc') # 1 == SUB, 2 == PUB

    if username == 'jane@mens.de' and topic == 't/1':
        response.status = 200

    return None

if __name__ == '__main__':

    bottle.debug(True)
    bottle.run(app,
        # server='python_server',
        host= "127.0.0.1",
        port= 8100)
```
### Django
views.py
```python
from django.shortcuts import render
from django.http import HttpResponse, HttpRequest
from mqtt_auth.selectors import auth_user, auth_superuser, auth_topic
from mqtt_auth.services import setup_test_data, teardown_test_data


def user(request: HttpRequest) -> HttpResponse:
    if request.method == 'POST':
        if auth_user(request.body):
            return HttpResponse(status=200)
        else:
            return HttpResponse(status=403)


def superuser(request: HttpRequest) -> HttpResponse:
    if request.method == 'POST':
        if auth_superuser(request.body):
            return HttpResponse(status=200)
        else:
            return HttpResponse(status=403)


def topic(request: HttpRequest) -> HttpResponse:
    if request.method == 'POST':
        if auth_topic(request.body):
            return HttpResponse(status=200)
        else:
            return HttpResponse(status=403)


def test_setup(request: HttpRequest) -> HttpResponse:
    if request.method == 'GET':
        setup_test_data()
        return HttpResponse(status=200)


def test_teardown(request: HttpRequest) -> HttpResponse:
    if request.method == 'GET':
        teardown_test_data()
        return HttpResponse(status=200)
```
selectors.py
```python
# Contains mypy-typed functions which query the ORM.
# Watch this https://www.youtube.com/watch?v=yG3ZdxBb1oo to understand.
import json
from typing import Dict
from mqtt_auth.models import User, Device


def auth_user(body: str) -> bool:
    body_json: Dict[str, str] = json.loads(body)
    username: str = body_json["username"]
    password: str = body_json["password"]
    try:
        User.objects.get(mqtt_username=username, mqtt_password=password)
        return True
    except Exception as e:
        return False


def auth_superuser(body: str) -> bool:
    body_json: Dict[str, str] = json.loads(body)
    username: str = body_json["username"]
    try:
        User.objects.get(mqtt_username=username, is_mqtt_superuser=True)
        return True
    except Exception as e:
        return False


def auth_topic(body: str) -> bool:
    body_json: Dict[str, str] = json.loads(body)
    username: str = body_json["username"]
    client_id: str = body_json["clientid"]
    topic: str = body_json["topic"]
    try:
        Device.objects.get(mqtt_client_id=client_id,
                           user=User.objects.get(mqtt_username=username))
        if topic.split("/")[2] != client_id:
            return False
        else:
            return True
    except Exception as e:
        return False
```
urls.py
```python
from django.urls import path
from . import views

urlpatterns = [
    path('user', views.user, name='user'),
    path('superuser', views.superuser, name='superuser'),
    path('topic', views.topic, name='topic'),
]
```
