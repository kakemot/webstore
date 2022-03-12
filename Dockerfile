FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["webstore/webstore.csproj", "webstore/"]
RUN dotnet restore "webstore/webstore.csproj"
COPY . .
WORKDIR "/src/webstore"
RUN dotnet build "webstore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "webstore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "webstore.dll"]
