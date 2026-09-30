# Etapa 1: Compilación (Build)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copiar archivos .csproj de cada proyecto para restaurar dependencias
COPY ["HerreraSystemAPI/HerreraSystemAPI.csproj", "HerreraSystemAPI/"]
COPY ["HerreraSystem.Application/HerreraSystem.Application.csproj", "HerreraSystem.Application/"]
COPY ["HerreraSystem.Domain/HerreraSystem.Domain.csproj", "HerreraSystem.Domain/"]
COPY ["HerreraSystem.Infrastructure/HerreraSystem.Infrastructure.csproj", "HerreraSystem.Infrastructure/"]
COPY ["HerreraSystemDomain/HerreraSystemDomain.csproj", "HerreraSystemDomain/"]

# Restaurar dependencias
RUN dotnet restore "HerreraSystemAPI/HerreraSystemAPI.csproj"  

# copiar el resto del codigo 
COPY . .
WORKDIR "/src/HerreraSystemAPI"
RUN dotnet publish "HerreraSystemAPI.csproj" -c Release -o /app/build /p:UseAppHost=false


# Etapa 3: Imagen final
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HerreraSystemAPI.dll"]