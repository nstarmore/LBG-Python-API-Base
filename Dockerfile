FROM python:latest

WORKDIR /app

COPY . .

RUN pip install -r "requirements.txt"

EXPOSE 80

ENTRYPOINT ["python", "lbg.py"]
