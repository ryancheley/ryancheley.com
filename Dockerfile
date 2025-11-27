FROM python:3.12-slim

WORKDIR /app

# Copy dependency files
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Generate the static site
RUN pelican content -s publishconf.py

# Serve the static files on port 80, listening on all interfaces
EXPOSE 80
CMD ["python", "-m", "http.server", "80", "--bind", "0.0.0.0", "--directory", "output"]
