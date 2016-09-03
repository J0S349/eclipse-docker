# Eclipse IDE inside Docker container
Created a Virtual Environment using Docker that would allow me to create and save projects using the Eclipse Mars 2 IDE. The Eclipse itself would run within the Virtual Environment, but the GUI itself would be displayed on the host screen through X11 forwarding. This project was created on ***Linux*** machine, but will be implementing it for Windows 10 later on.
## Requirements
- [Docker 1.11.2 (or newer)](https://www.docker.com/products/docker)
- X11 forwarding enable

## Verify if Docker installed
To verify that you have Docker installed, run this command in Terminal:
```sh
docker --version
```
You should get a result depending on what version you have. If not, click on this [link](https://www.docker.com/products/docker) and follow the instructions to install Docker on your Linux Machine.

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
In order to make plugins and projects persistance as you build and run your Docker, we need to create some folders that will be shared between the Virtual Environment and Linux host machine.
```
mkdir -p .eclipse-docker
mkdir workspace
```

## Building and Running Dockerfile
Now that you have created the two folders, just need execute the bash files already provided.
```sh
# This will build the Dockerfile (Can take a while)
source buildEclipse.sh
# This will run the Eclipse IDE within your computer
source runEclipse.sh
```
## Choosing right workspace
When you are prompted from Eclipse as to where you want your workspace to be. Put this:
```
/workspace
```
This is mainly due to this being the shared folder to save projects between the Virtual Machine and Linux host.

## Eclipse IDE not appearing
After executing the runEcilpse.sh and an error occurred, then there could be an issue with X11 forwarding. On Linux, try running this command ```xhost +``` to fix this issue. 
