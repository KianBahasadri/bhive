FROM python:3.12
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY automation_api.py automation_api.py
CMD ["fastapi", "run", "automation_api.py", "--port", "80"]

