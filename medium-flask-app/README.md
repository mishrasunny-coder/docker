# My Flask App

This is a simple Flask application that demonstrates basic routing and dynamic URL handling.

## Prerequisites

- Docker
- Docker Compose
- Make

## Project Structure

my-flask-app/
├── app.py
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── pyproject.toml
├── poetry.lock
├── .pre-commit-config.yaml
└── README.md


## Setup

### Step 1: Build Docker Images

To set up the environment and build the Docker images, run the following command:

```sh

make setup

```

### Step 2: Start the Application
To start the application, run:
```sh

make start

```

### Step 3: Stop the Application
To stop the application, run:
```sh

make stop

```

### Step 4: Clean Up Docker Images and Volumes
To clean up the Docker images and volumes, run:
```sh

make clean

```

## To Test the application manually follow the steps below

1. go to the desired post http://localhost:1000/MyNameIs
2. Then Type the name in the endpoint something like http://localhost:1000/MyNameIs/Sunny
3. App will display "Hello Sunny, How are you?"

# Running Locally with Poetry

If you prefer to run the application locally without Docker, follow these steps:

## Install Poetry:
```
curl -sSL https://install.python-poetry.org | python3 -

```

## Install Dependencies:
```

poetry install

```

## Run the Application:
```

poetry run flask run

```

# Environment Variables
The following environment variables are used in the application:

## FLASK_APP: 
Path to the Flask application file. (Default: /app.py)
## FLASK_RUN_HOST: 
Host address for the Flask application. (Default: 0.0.0.0)
## FLASK_RUN_PORT: 
Port for the Flask application. (Default: 5000)


# THANK YOU
