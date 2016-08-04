# Eclipse IDE inside Docker container
Created a Virtual Environment using Docker that would allow me to create and save projects using the Eclipse Mars 2 IDE. The Eclipse itself would run within the Virtual Environment, but the GUI itself would be displayed on the host screen through X11 forwarding. This project was created on Linux machine, but will be implementing it for Windows 10. 
## Requirements
- [Docker 1.11.2 (or newer)](https://www.docker.com/products/docker)
- X11 forwarding set up

## Verify if Docker installed
To verify that you have Docker installed, run this command in Terminal: 
```sh
docker --version
``` 
You should get a result depending on what version you have. If not, click on this [link](https://www.docker.com/products/docker) to install it on your Linux Machine. 

## Starting the Docker Daemon in Linux
Starting the Docker Daemon is different based on what Linux Distro.
  For Debain/Ubuntu/Centos:
  ```sh
  sudo service docker start
  ```
  For Fedora: 
  ```sh
  sudo systemctl start docker
  ```
  
## Configure work directory
In order to make plugins and projects persistance as you build and your Docker, we need to create some folders that will be shared with both the Virtual Environment and Linux host machine. 
```
mkdir -p .eclipse-docker
mkdir workspaces
```

## Building and Running Dockerfile
Now that you have created two folders, you just need execute the bash files already provided. 
```sh 
# This will build the Dockerfile (Can take a while)
source buildEclipse.sh 
# This will run the Eclipse IDE within your computer
source runEclipse.sh
```

## Eclipse IDE not appearing
After executing the runEcilpse.sh and an error occurred, then there is an issue with your X11 forwarding. Try running this command ```xhost +``` to fix this issue. 
