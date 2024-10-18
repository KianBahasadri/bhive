FROM python:3.12-alpine
WORKDIR /app
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY automation_api.py automation_api.py
RUN ln -s /usr/lib/libcrypto.so.3  /usr/lib/libcrypto.so
CMD ["fastapi", "run", "automation_api.py", "--port", "80"]

