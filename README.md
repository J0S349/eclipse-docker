# Eclipse IDE inside Docker container
Created a virtual environment using Docker that would allow me to create and save projects using the Eclipse Mars 2 IDE. The Eclipse itself would run within the Virtual Environment, but the GUI itself would be displayed on the host screen through X11 forwarding
## Requirements
- Docker 1.11.2
- X11 forwarding set up

## Configure work directory
When it comes to using this project in your Linux computer, we first need to create some directories that would be used to keep plugins and projects persistent when starting and stopping the Dockerfile. 
```
mkdir -p .eclipse-docker
mkdir workspaces
```
## Building and Running Dockerfile
Now that you have created two folders, you just need execute the bash files already provided. 
```sh 
# This will build the Dockerfile
source buildEclipse.sh 
# This will run the Eclipse IDE within your computer
source runEclipse.sh
```

## Eclipse IDE not appearing
After executing the runEcilpse.sh and an error occurred, then there is an issue with your X11 forwarding. Try running this command ```xhost +``` to fix this issue. 
