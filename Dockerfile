# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libc6-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app/

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Collect static files (assuming you have a collectstatic command in Django)
RUN python manage.py collectstatic --noinput

# Expose the port your app runs on
EXPOSE 8000

# Command to run the application
CMD ["gunicorn", "backend.asgi:application", "-k", "uvicorn.workers.UvicornWorker"]
