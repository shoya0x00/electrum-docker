# Electrum Docker
**Electrum daemon dockerized container with JSON RPC**

# How to run:
1. Create docker volume for electrum data
```
docker volume create electrum_data
```

2. Run docker container
```
docker run -d \
  --name electrum \
  -e ELECTRUM_USER=electrum \
  -e ELECTRUM_PASSWORD=electrumz \
  -v electrum_data:/data \
  -p 7000:7000 \
  --restart unless-stopped \
  ghcr.io/shoya0x00/electrum-docker:latest
```

***Change ELECTRUM_USER and ELECTRUM_PASSWORD. Those are yours JSON RPC credentials***
