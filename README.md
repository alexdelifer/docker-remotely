# docker-remotely

Automated builds through github actions.
Builds may be delayed up to 7 days.

## Usage

Docker:
```
docker run --rm --name remotely -v /appdata/remotely:/config -p 5000:5000 delifer/remotely:latest
```

Docker-Compose
```
version: "2"
services:
  remotely:
    image: delifer/remotely:latest
    ports:
      - 5000:5000
    volumes:
      - /appdata/remotely:/config

```
