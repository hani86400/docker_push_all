# 101_docker
Build a new docker image then push it to different Docker repositories include:  

Dcoker Hub 
GitHub  
AWS



## TIPS



### docker_install
```
dnf install -y docker 
```

### docker_install_compose_plugin 
```
DOCKER_COMPOSE_DIR='/usr/libexec/docker/cli-plugins'
DOCKER_COMPOSE_BIN="${DOCKER_COMPOSE_DIR}/docker-compose"
DOCKER_COMPOSE_URL='https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-linux-x86_64'

mkdir -pv   "${DOCKER_COMPOSE_DIR}"
curl -SL -o "${DOCKER_COMPOSE_BIN}" "${DOCKER_COMPOSE_URL}"
chmod +x    "${DOCKER_COMPOSE_BIN}"
```


### Add user to docker group to avoid using sudo in docker command
```
sudo usermod -aG docker ${USER} # add user to docker group to avoid using sudo in docker command
```


### Remark the (hani_nw_200) was create by command :   
```
docker network create --subnet=192.168.200.0/24 hani_nw_200
```


### commit changes on container 
##### STEP_01: run docker image
```
docker run --name pma -d phpmyadmin:5.2.1-apache
```
##### STEP_02: exe bash to access cli
```
docker exec -it  pma /bin/bash
```
##### STEP_03: run commands to install pakages or do conifgration:
```
apt update
apt install  openssh-server sudo curl iproute2 iputils-ping ufw -y
useradd -rm -d /home/u5555 -s /bin/bash -g root -G sudo -u 1000 u5555 
usermod -aG sudo u5555
echo 'root:123' | chpasswd
echo 'u5555:123' | chpasswd
echo 'u5555 ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/u5555_CONF 
mkdir -p /home/u5555/.ssh 
echo 'PUBLIC_KEY_VALUE' >> /home/u5555/.ssh/authorized_keys
chown -R u5555 /home/u5555/.ssh
chmod 700  /home/u5555/.ssh
chmod 400  /home/u5555/.ssh/authorized_keys
```

##### STEP_04: exist from docker bash by typing CTRL-P + CTRL-Q

##### STEP_05: commit to new image:
```
docker commit pma pma_ssh_1:202405
```
##### STEP_06: check new image:
```
docker image ls pma_ssh_1
```
##### output:
```
REPOSITORY   TAG       IMAGE ID       CREATED              SIZE
pma_ssh_1    202405    1f4c2e4c7728   About a minute ago   602MB
```



### Start (jupyter/minimal-notebook) :
```
docker run -p 8888:8888 --user root -v /volumes/jupyter_notebook:/home/jovyan  -e CHOWN_HOME=yes -e CHOWN_HOME_OPTS='-R'  jupyter/minimal-notebook:2023-05-08
```
or
```
docker run -p 8888:8888 --user root -v /volumes/jupyter_notebook:/home/jovyan  -e GRANT_SUDO=yes                          jupyter/minimal-notebook:2023-05-08
```


###### 2026_01_01

