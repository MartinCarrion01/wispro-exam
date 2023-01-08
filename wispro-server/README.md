<a name="top"></a>
# Wispro Exam - API

Aplicación que permite a proveedores de servicios de internet (ISP) registrarse y cargar los planes que ofrecen. También permite el registro de clientes que pueden crear solicitudes de contratación a planes ofrecidos por los ISP, las cuales el último podra o bien, rechazar o aceptar, creando una suscripcion del cliente al plan requerido en el ultimo caso.  
Los clientes tambien pueden solicitar un cambio de plan al proveedor, pudiendo este ultimo rechazar o aceptar estas solicitudes.

## Dependencias

Tenemos que cumplir las siguientes dependencias para que el proyecto funcione correctamente:

### Ruby

Versión 3.0.0 o mayor

### PostgreSQL

Este proyecto usa PostgreSQL como contenedor de datos.

Es importante mencionar que la aplicación buscara realizar una conexión con el servidor de base de datos inspeccionado el puerto TCP 5000.
Ademas usar las siguientes credenciales para acceder al servidor de BD: 

```
{
  "username" : "postgres",
  "password" : "password"
}
```

Podemos usar Docker para no tener que instalar PostgreSQL 

```
docker container run --name wispro-server -e POSTGRES_PASSWORD=root -d -p 5000:5432 postgres
```
O seguir las guías de instalación de PostgreSQL desde el sitio oficial: https://www.postgresql.org/

### API de PostgreSQL

Esta aplicación tambien necesita la API de PostgreSQL para poder realizar las consultas, por ejemplo: en Ubuntu la podemos instalar de la siguiente forma:

```
sudo apt-get install libpq-dev
```

# ¿Como instalar?

1ro: tenemos que clonar este proyecto en nuestra computadora.

2do: tenemos que instalar todas las gemas que necesita el proyecto con el siguiente comando:

```
bundle install
```

3ro: una vez instaladas todas las gemas, hay que crear la base de datos con el siguiente comando: 

```
bin/rails db:create
```

4to: una vez creada la base de datos, hay que correr las migraciones que crearan las tablas que necesita nuestra aplicación para su funcionamiento, esto lo podemos lograr con el siguiente comando: 

```
bin/rails db:migrate
```

5to (opcional): también podemos cargar un conjunto de datos de prueba que se encuentra definido en el archivo db/seeds.rb

```
bin/rails db:seed
```

# ¿Como usar la aplicación? 

Para poder empezar a usar esta aplicación, es necesario iniciar el servidor web con el comando:

```
bin/rails server
```

Para poder realizar peticiones al servidor, podemos usar por ejemplo: Postman o cURL. En este documento, se usará cURL en los ejemplos para cada endpoint

# Casos de uso de la aplicación: 


# Índice de endpoints
