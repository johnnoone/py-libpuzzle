FROM python:3.5
MAINTAINER Xavier Barbosa <clint.northwood@gmail.com>

RUN apt-get -y update \
  && apt-get -y install libpuzzle-dev libgd2-xpm-dev \
  && python -m pip install --upgrade pip
RUN python -m pip install cython
ADD . /app/
WORKDIR /app
RUN python -m pip install -r requirements-test.txt
ENV ERRORIST_DEVELOPMENT_MODE libpuzzle
