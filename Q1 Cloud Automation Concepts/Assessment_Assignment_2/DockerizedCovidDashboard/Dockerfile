#This file is already in a git repo and will not be called from here
#The file is located here: https://github.com/BFL-Psycho/cac-aa2-covid-dashboard-docker.git

FROM nginx:latest
RUN apt-get update && apt-get -y install git
RUN git clone https://github.com/broadinstitute/covid19-testing.git
RUN cd covid19-testing && sed -i 's|configFigureMenu();.*||g' ./index.html && sed -i 's|setChartGlobalConfig();.*||g' ./index.html
RUN cd covid19-testing && sed -i 's|let currentTime = new Date(new Date().toLocaleDateString());.*||g' ./index.html 
RUN cd covid19-testing && sed -i 's|render(\"3M\").*||g' ./index.html 
RUN cd covid19-testing && sed -i 's|let data.*|let apiEndpoint=\"\";let data=[];let currentTime;fetch(apiEndpoint).then(res=>res.json()).then(res=>{data=res;currentTime=new Date(new Date().toLocaleDateString());configFigureMenu();setChartGlobalConfig();render(\"3M\")});|g' ./index.html
COPY ./apiEndpoint ./covid19-testing
RUN cd covid19-testing && apiEndpoint=$(sed -n '1p' ./apiEndpoint) && sed -i "s|apiEndpoint=\"\"|apiEndpoint='$apiEndpoint'|g" ./index.html
RUN cp -r ./covid19-testing/* /usr/share/nginx/html
 