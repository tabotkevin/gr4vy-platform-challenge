FROM python:3.9

ADD . /auth-api

WORKDIR /auth-api

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD python main.py