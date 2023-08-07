FROM --platform=$BUILDPLATFORM python:3.11-alpine AS main
WORKDIR /code

COPY . /code
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["app.py"]
