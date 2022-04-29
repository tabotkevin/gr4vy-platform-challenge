FROM python:3.9

ADD . /core-api

WORKDIR /core-api

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 9000

CMD python main.py