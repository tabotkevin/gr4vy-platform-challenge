# platform-challenge

## Solution

- Install [HTTPie](https://github.com/httpie/httpie), on a mac you install with the below command.

```
$ brew install httpie
```

- Modify `/etc/hosts` file

```
$ sudo vim /etc/hosts
// enter your password
```
- Add the line

```
127.0.0.1      platform
```
- Propagate the changes:

```
$ sudo killall -HUP mDNSResponder
```

- Clone this repository and start the services

```
$ git clone https://github.com/tabotkevin/gr4vy-platform-challenge.git
$ cd gr4vy-platform-challenge
$ git fetch
$ git checkout answer
$ docker-compose up
```

- In another terminal, send a request to the `http://platform/auth/token` with one of the username and password combinatioins in `auth-api/users.json`

```
$ http post http://platform/auth/token username=alice password=password
```

- Expect a response like this

```
HTTP/1.1 200
Connection: keep-alive
Content-Length: 179
Content-Type: application/json
Date: Fri, 29 Apr 2022 02:05:39 GMT
Server: nginx/1.21.6

{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6ImFsaWNlIiwiZW5hYmxlZCI6dHJ1ZSwiZXhwIjoxNjUxMTk3OTY5fQ.ZzlsWB7QpN636exFRxJZoQjzSmBrtwozHSixVigiQ70"
}
```

- Use the above token make the next request to `http://platform/transaction`

```
$ http post http://platform/transaction token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6ImFsaWNlIiwiZW5hYmxlZCI6dHJ1ZSwiZXhwIjoxNjUxMTk3OTY5fQ.ZzlsWB7QpN636exFRxJZoQjzSmBrtwozHSixVigiQ70 user_id=1 amount=100 currency=EUR
```

- Expect a response like this

```
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 44
Content-Type: application/json
Date: Fri, 29 Apr 2022 02:05:45 GMT
Server: nginx/1.21.6

{
    "amount": 100,
    "currency": "EUR",
    "user_id": 1
}
```

## Proof
![proof](proof.png)

## Background

Gr4vy is a building a payment orchestration platform.

As a Platform engineer, you are tasked with improving the engineering efficiency by producing automation tools that provision services in an efficient, predictable and reproducible way.

In this exercise we use [HTTPie](https://github.com/httpie/httpie) in our examples for clarity.

## Architecture Overview

```
+----------------------------------+
|            Merchant              |
+-+--------^------------+--------^-+
  |        |            |        |
 (1)      (2)          (3)      (5)
  |        |            |        |
+-v--------+-+        +-v--------+-+        +-----------------+
|  Auth API  |        |  Core API  |        |  PSP Connector  | 
+------------+        +------+-----+        +---------^-------+
                             |                        |
                            (4)                      (6)
                             |                        |
                      +------v------------------------+-------+
                      |          Redis Message Queue          |
                      +---------------------------------------+
```

There are 3 distinct services:

- [Auth API] - Creates authentication tokens to valid users.
- [Core API] - Processes transaction requests.
- [PSP Connector] - Processes the transactions with a Payment Service Provider (PSP).

A transaction flow is as follows:

1. A merchant authenticates with the [Auth API] by providing a valid username and password.
2. An authentication token that is valid for 30 seconds is returned.
3. Use this authentication token to make a transaction request to the [Core API].
4. The [Core API] submits the transaction to a message queue for further background processing.
5. A successful response is returned.
6. Meanwhile, a [PSP Connector] processes the transaction from the message queue by connecting to a Payment Service Provider.

We use environment variables to configure a service.

## Your task

- Read the documentation for each service. Run and test them to make sure they work as expected.
- Once you're familiar with the services, use your preferred tools to automate provisioning of a **local development** environment.
- Be sure to include external dependencies like Redis and configuration management.
- In order for a microservices-based architecture to work best, implement a HTTP router in front of the services that routes requests to the correct service. A popular solution is path-based routing:
    - http://platform/auth/* → http://auth-api/*
    - http://platform/transaction/* → http://core-api/*
- Make your automation available on a public GitHub repository with a `README` on how to get things started.

Don't worry too much about making this production ready. We may discuss production considerations with you later on.

Please spend no more than 1-2 hours on this exercise.

## Bonus (Optional)

- Containerise services.
- Apply the [Twelve Factor App](https://12factor.net/) methodology.

[Auth API]: auth-api
[Core API]: core-api
[PSP Connector]: psp-connector