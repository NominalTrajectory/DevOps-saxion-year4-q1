#This file is already in a git repo and will not be called from here
#The file is located here: https://github.com/BFL-Psycho/cac-aa2-covid-dashboard-docker.git

#Description: Setting up the basic enviroment
FROM nginx:latest
RUN apt-get update && apt-get -y install git

#Description: Download the Covid dashbaord website from GitHub
RUN git clone https://github.com/broadinstitute/covid19-testing.git

#Description: Remove line related to data in the index files itself
RUN cd covid19-testing && sed -i 's|configFigureMenu();.*||g' ./index.html && sed -i 's|setChartGlobalConfig();.*||g' ./index.html
RUN cd covid19-testing && sed -i 's|let currentTime = new Date(new Date().toLocaleDateString());.*||g' ./index.html 
RUN cd covid19-testing && sed -i 's|render(\"3M\").*||g' ./index.html 

#Description: Redplace the line with data with a function to call the API to get data from the MongoDB database
RUN cd covid19-testing && sed -i 's|let data.*|let apiEndpoint=\"\";let data=[];let currentTime;fetch(apiEndpoint).then(res=>res.json()).then(res=>{data=res;currentTime=new Date(new Date().toLocaleDateString());configFigureMenu();setChartGlobalConfig();render(\"3M\")});|g' ./index.html
COPY ./apiEndpoint ./covid19-testing
RUN cd covid19-testing && apiEndpoint=$(sed -n '1p' ./apiEndpoint) && sed -i "s|apiEndpoint=\"\"|apiEndpoint='$apiEndpoint'|g" ./index.html

#Description: Copy all files to the nginx serve directory
RUN cp -r ./covid19-testing/* /usr/share/nginx/html
 