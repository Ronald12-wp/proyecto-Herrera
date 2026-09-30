# Etapa 1: Compilación (Build)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copiar archivos .csproj de cada proyecto
COPY ["HerreraSystemAPI/HerreraSystemAPI.csproj", "HerreraSystemAPI/"]
COPY ["HerreraSystem.Application/HerreraSystem.Application.csproj", "HerreraSystem.Application/"]
COPY ["HerreraSystem.Infrastructure/HerreraSystem.Infrastructure.csproj", "HerreraSystem.Infrastructure/"]
COPY ["HerreraSystemDomain/HerreraSystem.Domain.csproj", "HerreraSystemDomain/"]
COPY ["HerreraSystem.Tests/HerreraSystem.Tests.csproj", "HerreraSystem.Tests/"]

# Restaurar dependencias
RUN dotnet restore "HerreraSystemAPI/HerreraSystemAPI.csproj"

# Copiar todo el resto del código
COPY . .
WORKDIR "/src/HerreraSystemAPI"
RUN dotnet publish "HerreraSystemAPI.csproj" -c Release -o /app/build /p:UseAppHost=false

# Etapa 2: Imagen final
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "HerreraSystemAPI.dll"]