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

### docker_conf (user)
```
#Add user to docker group to avoid using sudo in docker command
sudo usermod -aG docker ${USER} # add user to docker group to avoid using sudo in docker command
```


### docker network 
```
docker network create --subnet=192.168.200.0/24 hani_nw_200
```

### docker pull 
```
docker pull busybox:1.37.0-uclibc
```

### docker build 
```
docker buildx install
docker buildx create --use
export DOCKER_BUILDKIT=1
DOCKER_BUILDKIT=1 docker build . 


cd $CONTEXT_DIR
docker build . --no-cache -f "${DOCKER_FILE}" -t "${IMAGE_TAG}"
```

### docker compose 
```
cd $DC_DIR # folder contains .env file
docker compose -f dc_pmassh7 up
docker compose -f dc_pmassh7 up -d
docker compose -f dc_pmassh7 sown
```

### docker run 
```
docker run -d --name bb_httpd_1 -p 3001:3000 -e HTML_INDEX_TITLE="By_server_1" -e HTML_INDEX_APP="WEB_SITE" -e HTML_INDEX_SERVER_ID="1"  hani86400/busybox-httpd-env:1222
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

### helpful Docker functions and aliass
```
export S11_DC_DIR='/opt/s11_wd/dc'


alias dc_cp='docker cp '
alias dc_nw='docker network ls'
alias dc_img='docker images'

function dc_ps(){ docker stats --no-stream -a ; echo ' ' ; docker ps -a ; }
function dc_kill_all_container(){ docker stop  $(docker ps -a -q) ; docker rm    $(docker ps -a -q) ; dc_ps ; }
function dc_kill_container(){ 
local T_CONTAINER_NAME=$1
local T_CONTAINER_ID=$( docker ps -a | grep  "${T_CONTAINER_NAME}" | awk '{print $1}' )
docker stop ${T_CONTAINER_ID}
docker rm   ${T_CONTAINER_ID}
}


dc_2_bb_d_h(){ cd "${S11_DC_DIR}" ; docker compose -f dc_bb_d_h.yaml      down ; docker compose -f dc_bb_d_h.yaml     up -d ; }
dc_1_bb_d_h(){ cd "${S11_DC_DIR}" ; docker compose -f dc_bb_d_h.yaml      down ; docker compose -f dc_bb_d_h.yaml     up    ; }
dc_0_bb_d_h(){ cd "${S11_DC_DIR}" ; docker compose -f dc_bb_d_h.yaml      down                                              ; }



dc_2_n8n(){ cd "${S11_DC_DIR}" ; docker compose -f dc_n8n.yaml      down ; docker compose -f dc_n8n.yaml     up -d ; }
dc_1_n8n(){ cd "${S11_DC_DIR}" ; docker compose -f dc_n8n.yaml      down ; docker compose -f dc_n8n.yaml     up    ; }
dc_0_n8n(){ cd "${S11_DC_DIR}" ; docker compose -f dc_n8n.yaml      down                                           ; }



dc_2_m1me(){ cd "${S11_DC_DIR}" ; docker compose -f dc_m1me.yaml    down ; docker compose -f dc_m1me.yaml    up -d ; }
dc_1_m1me(){ cd "${S11_DC_DIR}" ; docker compose -f dc_m1me.yaml    down ; docker compose -f dc_m1me.yaml    up    ; }
dc_0_m1me(){ cd "${S11_DC_DIR}" ; docker compose -f dc_m1me.yaml    down                                           ; }
dc_2_m2(){   cd "${S11_DC_DIR}" ; docker compose -f dc_m2.yaml      down ; docker compose -f dc_m2.yaml      up -d ; }
dc_1_m2(){   cd "${S11_DC_DIR}" ; docker compose -f dc_m2.yaml      down ; docker compose -f dc_m2.yaml      up    ; }
dc_0_m2(){   cd "${S11_DC_DIR}" ; docker compose -f dc_m2.yaml      down                                           ; }
dc_2_me82(){ cd "${S11_DC_DIR}" ; docker compose -f dc_me82.yaml    down ; docker compose -f dc_me82.yaml    up -d ; }
dc_1_me82(){ cd "${S11_DC_DIR}" ; docker compose -f dc_me82.yaml    down ; docker compose -f dc_me82.yaml    up    ; }
dc_0_me82(){ cd "${S11_DC_DIR}" ; docker compose -f dc_me82.yaml    down                                           ; }
dc_2_me83(){ cd "${S11_DC_DIR}" ; docker compose -f dc_meatlas.yaml down ; docker compose -f dc_meatlas.yaml up -d ; }
dc_1_me83(){ cd "${S11_DC_DIR}" ; docker compose -f dc_meatlas.yaml down ; docker compose -f dc_meatlas.yaml up    ; }
dc_0_me83(){ cd "${S11_DC_DIR}" ; docker compose -f dc_meatlas.yaml down                                           ; }

dc_exec_m1_mongosh()     { docker exec -it mongodb1 mongosh "mongodb://admin:password@localhost:27017" ; }
dc_exec_m1_env()         { docker exec -it mongodb1 env ; }
dc_exec_m1_bash()        { docker exec -it mongodb1 /bin/bash ; }
dc_exec_m1_mongoimport() { docker exec -i  mongodb1 mongoimport --db=mycompany --collection=employees  --file=/data/employees.json    --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }
dc_exec_m1_mongoexport() { docker exec -i  mongodb1 mongoexport --db=mycompany --collection=employees  --out=/data/exp_employees.json --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }

dc_exec_m2_mongosh()     { docker exec -it mongodb2 mongosh "mongodb://admin:password@localhost:27017" ; }
dc_exec_m2_env()         { docker exec -it mongodb2 env ; }
dc_exec_m2_bash()        { docker exec -it mongodb2 /bin/bash ; }
dc_exec_m2_mongoimport() { docker exec -i  mongodb2 mongoimport --db=mycompany --collection=employees  --file=/data/employees.json    --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }
dc_exec_m2_mongoexport() { docker exec -i  mongodb2 mongoexport --db=mycompany --collection=employees  --out=/data/exp_employees.json --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }


dc_run_opensusessh() { docker run -p 22156:22 --name opensusessh31 -it opensusessh:15.6 "/usr/sbin/sshd" "-D" ; }

dc_run_bb1() { docker run -d --name bb_httpd_1 -p 3001:3000 -e HTML_INDEX_TITLE="By_server_1" -e HTML_INDEX_APP="WEB_SITE" -e HTML_INDEX_SERVER_ID="1"  hani86400/busybox-httpd-env:1222 ; }
dc_run_bb2() { docker run -d --name bb_httpd_2 -p 3002:3000 -e HTML_INDEX_TITLE="By_server_2" -e HTML_INDEX_APP="WEB_SITE" -e HTML_INDEX_SERVER_ID="2"  hani86400/busybox-httpd-env:1222 ; }
dc_run_bb3() { docker run -d --name bb_httpd_3 -p 3003:3000 -e HTML_INDEX_TITLE="By_server_3" -e HTML_INDEX_APP="WEB_SITE" -e HTML_INDEX_SERVER_ID="3"  hani86400/busybox-httpd-env:1222 ; }


#######################################################################
# f u n c t i o n                                       [2025_03_07 ] #
                 docker_build() {
# $1 : DOCKER_CONTEXT
# $1 : IMAGE_NAME_TAG
# $2 : DOCKER_FILE

#######################################################################
    # usage: docker_build DOCKER_CONTEXT IMAGE_NAME_TAG DOCKER_FILE

    local context image_tag dockerfile

    if [ $# -lt 3 ]; then
        echo "Usage: docker_build DOCKER_CONTEXT IMAGE_NAME_TAG DOCKER_FILE"
        return 1
    fi

    context="$1"
    image_tag="$2"
    dockerfile="$3"

    if ! cd "$context"; then
        echo -e "\e[1;91mError: invalid DOCKER_CONTEXT: $context\e[0m"
        return 1
    fi

    echo -e "Try to build: \e[1;96m${image_tag}\e[0m using \e[1;93m${dockerfile}\e[0m"

    # remove old image if it exists, ignore failure
    docker image rm "$image_tag" 2>/dev/null

    # build new one
    docker build . --no-cache -f "$dockerfile" -t "$image_tag"

    # list what we built to feel productive
    docker image ls | grep --color=auto "$image_tag"

} # f u n c t i o n [END] #############################################



```
###### 2026_01_02

