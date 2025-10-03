# Guía: App.config (solo local, NO se versiona)

## Ubicación
src/App/App.config (copiado desde src/App/App.config.template.config)

## Claves requeridas
- appSettings:
  - ActiveDb: "Docker" | "Local"
  - AppTitulo: "SuiteMDI-EduSQL"
- connectionStrings:
  - SqlDocker: cadena para 127.0.0.1,2333 (Docker)
  - SqlLocal:  cadena para instancia local (opcional)

## Ejemplo mínimo (reemplaza TU_PASSWORD_SA)
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.8" />
  </startup>

  <appSettings>
    <add key="ActiveDb" value="Docker" />
    <add key="AppTitulo" value="SuiteMDI-EduSQL" />
  </appSettings>

  <connectionStrings>
    <add name="SqlDocker"
         connectionString="Server=127.0.0.1,2333;Database=Ejemplo_SIN_Encripcion;User ID=sa;Password=TU_PASSWORD_SA;TrustServerCertificate=True;MultipleActiveResultSets=True;"
         providerName="System.Data.SqlClient" />
    <add name="SqlLocal"
         connectionString="Server=localhost;Database=Ejemplo_SIN_Encripcion;Integrated Security=True;TrustServerCertificate=True;MultipleActiveResultSets=True;"
         providerName="System.Data.SqlClient" />
  </connectionStrings>
</configuration>

## Notas
- No publiques este archivo. Está ignorado por .gitignore.
- Si cambias ActiveDb, la app tomará esa cadena.
- Para producción: NO usar `sa`; crear login/usuario con permisos mínimos.