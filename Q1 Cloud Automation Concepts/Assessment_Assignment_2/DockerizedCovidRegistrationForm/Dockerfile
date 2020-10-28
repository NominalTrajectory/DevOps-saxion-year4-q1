FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env

RUN apt-get update && apt-get install git
WORKDIR /myWebApp 
RUN git clone https://github.com/looking4ward/nhs-cac-docker-dotnetwebapp.git
RUN cd nhs-cac-docker-dotnetwebapp && dotnet restore
RUN cd nhs-cac-docker-dotnetwebapp && dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /myWebApp
COPY --from=build-env /myWebApp/nhs-cac-docker-dotnetwebapp/out .
ENTRYPOINT ["dotnet", "myWebApp.dll"]