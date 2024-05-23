# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /app
EXPOSE 80

# Copy the csproj and restore as distinct layers
COPY *.sln .
COPY MountainBound/*.csproj ./MountainBound/
RUN dotnet restore

# Copy everything else and build
COPY . .
WORKDIR /app/MountainBound
RUN dotnet publish -c Release -o out

# Use the ASP.NET Core runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build /app/MountainBound/out .
ENTRYPOINT ["dotnet", "MountainBound.dll"]
