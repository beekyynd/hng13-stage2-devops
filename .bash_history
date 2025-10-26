nano docker-compose.yml
nano .env.example
nano nginx.conf.template
nano README.md
docker compose up -d
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Add the repository
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker Engine and Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# Test
docker --version
docker compose version
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian bookworm stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
docker --version
docker compose version
sudo docker run hello-world
sudo usermod -aG docker $USER
docker compose up -d
# Public endpoint via nginx
curl -i http://localhost:8080/version
# Should return 200 and headers:
# X-App-Pool: blue
# X-Release-Id: <value from .env RELEASE_ID_BLUE>
nano .env
docker compose up -d
docker ps
nano docker-compose.yml
# Public endpoint via nginx
curl -i http://localhost:8080/version
# Should return 200 and headers:
# X-App-Pool: blue
# X-Release-Id: <value from .env RELEASE_ID_BLUE>
docker logs nginx
docker ps -a
docker logs nginx_bluegreen
ls
nano nginx.conf.template
# Public endpoint via nginx
curl -i http://localhost:8080/version
# Should return 200 and headers:
# X-App-Pool: blue
# X-Release-Id: <value from .env RELEASE_ID_BLUE>
ls
docker compose down
docker compose build
docker compose up -d
docker ps
ls
nano nginx.conf.template
nano docker-compose.yml
ls
nano docker-compose.yml
nano nginx.conf.template
docker compose down
docker compose up -d
docker logs nginx_bluegreen
nano docker-compose.yml
ls
nano docker-compose.yml
docker compose down
docker compose up -d
docker ps
docker logs nginx_bluegreen
nano nginx.conf.template
docker compose down
docker compose up -d
docker logs nginx_bluegreen
nano nginx.conf.template
nano docker-compose.yml
docker compose down
docker compose up -d
nano docker-compose.yml
docker compose down
docker compose up -d --build
docker logs nginx_bluegreen
nano docker-compose.yml
docker compose down
docker compose up -d --build
docker logs nginx_bluegreen
nano nginx.conf.template
docker compose down
docker compose up -d --build
docker logs nginx_bluegreen
nano docker-compose.yml
nano nginx.conf.template
docker compose down
docker compose up -d --build
docker logs nginx_bluegreen
nano docker-compose.yml
docker compose down
docker compose up -d --build
docker logs nginx_bluegreen
docker compose down
docker compose up -d
