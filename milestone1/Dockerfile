# base image  
FROM python:slim-bullseye   
# setup environment variable  
ENV DockerHOME=/home/app/Koffeeluv/

# set work directory  
RUN mkdir -p $DockerHOME  

# where your code lives  
WORKDIR $DockerHOME  

# set environment variables  
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

# install dependencies  
RUN pip3 install --upgrade pip

# copy whole project to your docker home directory. 
ADD /app/* $DockerHOME  
# run this command to install all dependencies  
RUN pip3 install -r requirements.txt  
# port where the Django app runs  
EXPOSE 8000  
# start server  
CMD ["./manage.py", "runserver", "0.0.0.0:8000"]  