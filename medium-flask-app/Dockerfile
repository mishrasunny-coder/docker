FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip curl

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Copy the application and dependency files into the container
COPY pyproject.toml poetry.lock /app/
COPY app.py /app/

# Set the working directory
WORKDIR /app

# Install dependencies using Poetry
RUN /root/.local/bin/poetry install

# Expose port 5000
EXPOSE 5000

# Set environment variables for Flask app
ENV FLASK_APP=/app/app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# Run the Flask app
CMD ["/root/.local/bin/poetry", "run", "flask", "run"]
