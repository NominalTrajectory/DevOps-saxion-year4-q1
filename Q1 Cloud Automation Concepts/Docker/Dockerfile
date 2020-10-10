#cac-simple-webapp

FROM ubuntu
LABEL Description="CAC Simple Webapp" Vendor="CAC" Version="1.0"
RUN apt-get update && apt-get install -y 
RUN apt install nodejs -y 
RUN apt install npm -y 
RUN apt install git -y 
RUN git clone https://github.com/TimothySealy/cac-simple-webapp 
RUN cd cac-simple-webapp 
RUN npm i 
RUN export PORT=80 
RUN npm start

