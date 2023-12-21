
# NETCONF Development Environment on  Docker 

NETCONF development environment on docker

* [libyang](https://github.com/CESNET/libyang)
* [sysrepo](https://github.com/sysrepo/sysrepo)
* [libnetconf2](https://github.com/CESNET/libnetconf2)
* [netopeer2](https://github.com/CESNET/netopeer2)

## Instructions

### Prerequisite

Create Docker network for test

```
docker network create netconf
```

### NETCONF Server

Run docker image for netconf-server

```
docker run --name netconf-server \
	--rm \
	--network netconf \
	-p 830:830 \
	-it \
	euikook/netconf \
	bash

```

Run Netopper2 Server on docker shell

```
netopeer2-server -d -v2
```

### NETCONF Client

Run docker image for netconf-client

```
docker run --name netconf-client \
    --rm \
    --network netconf \
    -it \
    euikook/netconf \
    bash
```

Run Netopeer2 Test Client on docker shell

```
netopeer2-cli
```


Connect to netconf-server run on netopeer2-cli 
```
connect --ssh --host netconf-server --login netconf
```

Sample output:
```
> connect --ssh --host netconf-server --login netconf
The authenticity of the host 'netconf-server' cannot be established.
ssh-rsa key fingerprint is a4:06:93:97:84:18:6b:56:15:d1:8f:0b:a2:61:75:4e:e0:cc:93:fd.
Are you sure you want to continue connecting (yes/no)? yes
netconf@netconf-server password: 
```

> Password is `netconf`



Retrieve all data from  server using `get` RPC
```
> get
```

Retrieve configuration data from server using get-config RPC
```
> get-config --source running
```
