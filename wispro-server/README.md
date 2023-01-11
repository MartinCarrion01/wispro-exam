<a name="top"></a>
# Wispro Exam - API

Aplicación que permite a proveedores de servicios de internet (ISP) registrarse y cargar los planes que ofrecen. También permite el registro de clientes que pueden crear solicitudes de contratación a planes ofrecidos por los ISP, las cuales el último podra o bien, rechazar o aceptar, creando una suscripcion del cliente al plan requerido en el ultimo caso.  
Los clientes tambien pueden solicitar un cambio de plan al proveedor, pudiendo este ultimo rechazar o aceptar estas solicitudes.

# Índice
- [Dependencias](#dependencias)
- [¿Como instalar?](#instalar)
- [¿Como usar la aplicación?](#usar)
- [Descripcion general de la aplicación](#descripcion-app)
- [Indice de rutas expuestas](#indice)

<a name='dependencias'></a>
# Dependencias

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
<a name='instalar'></a>
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
<a name='usar'></a>
# ¿Como usar la aplicación? 

Para poder empezar a usar esta aplicación, es necesario iniciar el servidor web con el comando:

```
bin/rails server
```

Para poder realizar peticiones al servidor, podemos usar por ejemplo: Postman o cURL. En este documento, se usará cURL en los ejemplos para cada endpoint

<a name='descripcion-app'></a>
# Descripción general de la aplicación: 

## Casos de uso principales de la aplicación: 

<img src="/wispro-server/Diagrama de casos de uso - Wispro Exam.png" alt="Diagrama de CU">

## Diagrama de clases del dominio del problema: 

<img src="/wispro-server/Diagrama de clases - Wispro Exam.png" alt="Diagrama de clases">

## Descripcion de cada clase del dominio: 

### Provider

Representa un proveedor de servicios de internet, este posee muchos planes. 

### Plan

Representa un plan ofrecido por el proveedor de servicios de internet con su correspondiente descripción (por ej: "50 mb asimétrico")

### Client

Representa un cliente que contrata uno de los planes que ofrece un proveedor específico. Esta representación del cliente esta compuesta por un nombre de usuario (username), la contraseña encriptada (password_digest) y su nombre completo (first_name y last_name)

### Subscription

Representa la suscripción a un plan específico de parte del cliente del proveedor. Cabe recalcar que un cliente puede suscribirse a muchos planes, pero este no puede suscribirse a otro plan de un mismo proveedor, en otras palabras, puede estar suscrito a muchos planes pero cada uno con distinto proveedor necesariamente.

### SubscriptionRequest

Representa una solicitud de contratación de un plan. El cliente la crea para, valga la redundancia, poder contratar un plan ofrecido por algún ISP. El proveedor dueño del plan al que el cliente solicita contratar, decide si aceptar o rechazar esta solicitud. Si la acepta, crea una subscripcion activa entre el cliente y el plan solicitado. 
El cliente no puede solicitar una contratación de un plan a un proveedor si este ya se encuentra suscrito activamente a otro plan del mismo proveedor o si tambien tiene una solicitud al mismo proveedor que todavía no ha sido ni aprobada o rechazada.
El proveedor tampoco puede aprobar o rechazar solicitudes de contratación de plan que no le pertenezcan.

### SubscriptionChangeRequest

Representa una solicitud de cambio de plan. El cliente la crea para poder cambiar el plan al que esta suscrito actualmente a otro plan ofrecido por el mismo proveedor. El proveedor dueño de ambos planes, al que esta suscrito actualmente al cliente y al que desea cambiar, decide si aceptar o rechazar esta solicitud. Si la acepta, crea una nueva suscripción activa entre el cliente y el plan al que quería cambiar el cliente y deja inactiva la suscripción previa que tenía. 
El cliente no puede solicitar una contratación de cambio de plan si no cuenta con una suscripción activa a cualquier plan del proveedor. Tampoco si ya tiene otra solicitud de cambio de plan pendiente de revisión o si el plan al que quiere cambiarse no pertenece al proveedor de su plan actual.
El proveedor tampoco puede aprobar o rechazar solicitudes de cambio de plan que no le pertenezcan.

<a name="indice"></a>
# Índice de rutas

- [Proveedor](#proveedor)
	- [Registrar proveedor](#registrar-proveedor)
  - [Obtener token de autorización](#token-proveedor)
  - [Listar proveedores con sus planes agrupados](#listar-grupos-plan)
- [Plan](#plan-link)
	- [Registrar plan](#registrar-plan)
- [Cliente](#cliente)
	- [Registrar cliente](#registrar-cliente)
	- [Login](#login)
	- [Cliente actual](#cliente-actual)
- [Solicitud de contratacion](#solicitud-contratacion)
	- [Crear solicitud de contratacion](#crear-solicitud-contratacion)
	- [Listar solicitudes de contratación del cliente](#solicitud-contratacion-cliente)
	- [Listar solicitudes de contratacion rechazadas en el ultimo mes a un cliente](#listar-solicitud-rechazada)
  - [Actualizar estado de solicitud de contratación](#actualizar-estado-solicitud)
- [Solicitud de cambio de plan](#solicitud-cambio)
  - [Crear solicitud de cambio de plan](#crear-solicitud-cambio)
  - [Actualizar estado de solicitud de cambio de plan](#actualizar-estado-cambio)

# <a name='proveedor'></a> Proveedor

## <a name='registrar-proveedor'></a> Registrar proveedor
[Volver al índice](#indice)

<p>Registra un proveedor con su nombre</p>

### Ruta
```
POST /api/v1/providers
```
### Headers 

```
{
  Content-Type: application/json
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>provider</td>
    <td>Objeto JSON que representa el proveedor</td>
  </tr>
  <tr>
    <td>provider.name</td>
    <td>Nombre del proveedor</td>
  </tr>
</table>

### Ejemplo

```
curl -X POST 'http://127.0.0.1:3000/api/v1/providers' \
-H 'Content-Type: application/json' \
--data-raw '{
    "provider": {
        "name": "ISP-EXAMPLE"
    }
}'
```

### Respuesta exitosa

```
201 CREATED
{
    "provider": {
        "id": 4,
        "name": "ISP-EXAMPLE",
        "created_at": "2023-01-09T00:21:40.485Z",
        "updated_at": "2023-01-09T00:21:40.485Z"
    }
}
```

### Respuesta con error

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```

## <a name='token-proveedor'></a> Obtener token de autorización
[Volver al índice](#indice)

<p>Obtiene el token de autorización para un proveedor especifico, ciertas operaciones necesitan este token para poder ser completadas</p>

### Ruta
```
GET /api/v1/providers/:id/get_token
```
### Headers 

```
{
  Content-Type: application/json
}
```
### Query params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>id</td>
    <td>Representa el id del proveedor al que queremos recuperar su token de autorización</td>
  </tr>
</table>

### Ejemplo

```
curl -X GET 'http://127.0.0.1:3000/api/v1/providers/2/get_token'
```

### Respuesta exitosa

```
200 OK
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJwcm92aWRlcl9pZCI6MiwiZXhwIjoxNjczODI4OTE4fQ.Y6cdn_CKD9n-LKBqpXHy74Q97aeCDVdl5aMeYRUAdwA"
}
```

### Respuesta con error

```
404 NOT_FOUND
{
    "message": "El proveedor solicitado no existe"
}
```

## <a name='listar-grupos-plan'></a> Listar proveedores con sus planes agrupados
[Volver al índice](#indice)

<p>Lista todos los provedores juntos el grupo de planes que estos ofrecen cada uno.</p>

### Ruta
```
GET /api/v1/providers/get_plans
```
### Headers 

```
{
  Content-Type: application/json
}
```

### Ejemplo

```
curl -X GET 'http://127.0.0.1:3001/api/v1/providers/get_plans'
```

### Respuesta exitosa

```
200 OK
{
    "providers": [
        {
            "id": 1,
            "name": "ISP1",
            "plans": [
                {
                    "id": 1,
                    "description": "50 mb simetrico"
                },
                {
                    "id": 4,
                    "description": "10 mb simetrico"
                }
            ]
        },
        {
            "id": 2,
            "name": "ISP2",
            "plans": [
                {
                    "id": 2,
                    "description": "100 mb asimetrico"
                },
                {
                    "id": 7,
                    "description": "10 mb simetrico"
                }
            ]
        },
        {
            "id": 3,
            "name": "ISP3",
            "plans": [
                {
                    "id": 3,
                    "description": "100 mb simetrico"
                },
                {
                    "id": 8,
                    "description": "10 mb simetrico"
                }
            ]
        },
        {
            "id": 4,
            "name": "ISP4",
            "plans": [
                {
                    "id": 5,
                    "description": "10 mb simetrico"
                }
            ]
        },
        {
            "id": 5,
            "name": "ISP5",
            "plans": [
                {
                    "id": 6,
                    "description": "10 mb simetrico"
                }
            ]
        }
    ]
}
```

# <a name='plan-link'></a> Plan

## <a name='registrar-plan'></a> Registrar plan
[Volver al índice](#indice)

<p>Un proveedor registra uno de sus planes con su descripción correspondiente. Se necesita tener un token de autorización en el encabezado de la petición para llevar a cabo esta operación</p>

### Ruta
```
POST /api/v1/plans
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>plan</td>
    <td>Objeto JSON que representa el plan</td>
  </tr>
  <tr>
    <td>plan.description</td>
    <td>Descripción del plan a crear</td>
  </tr>
</table>

### Ejemplo

```
curl -X POST 'http://127.0.0.1:3000/api/v1/plans' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJwcm92aWRlcl9pZCI6MywiZXhwIjoxNjczNzQ2OTkyfQ.rqnJD8uBVQzvDqlMYpbxPeMW9K36NjhqXZ0V5FnGdZc' \
-H 'Content-Type: application/json' \
--data-raw '{
    "plan": {
        "description": "40mb asimetrico"
    }
}'
```

### Respuesta exitosa

```
201 CREATED
{
    "plan": {
        "id": 4,
        "description": "40mb asimetrico",
        "provider_id": 3,
        "created_at": "2023-01-09T00:35:06.691Z",
        "updated_at": "2023-01-09T00:35:06.691Z"
    }
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un proveedor usando el token de autorizacion"
}
```

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```

# <a name='cliente'></a> Cliente

## <a name='registrar-cliente'></a> Registrar cliente
[Volver al índice](#indice)

<p>Un cliente se registra con su nombre de usuario, contraseña, confirmación de contraseña y nombre completo</p>

### Ruta
```
POST /api/v1/clients
```
### Headers 

```
{
  Content-Type: application/json
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>client</td>
    <td>Objeto JSON que representa el cliente</td>
  </tr>
  <tr>
    <td>client.username</td>
    <td>Nombre de usuario del cliente que luego usara para logearse</td>
  </tr>
	  <tr>
    <td>client.password</td>
    <td>Contraseña del cliente que luego usara para logearse, tiene que tener una longitud mayor a 8 caracteres</td>
  </tr>
  	  <tr>
    <td>client.password_confirmation</td>
    <td>Confirmación de la contraseña elegida por el cliente</td>
  </tr>
  </tr>
  	  <tr>
    <td>client.first_name</td>
    <td>Primer nombre del cliente</td>
  </tr>
  	  <tr>
    <td>client.last_name</td>
    <td>Apellido del cliente</td>
  </tr>
</table>

### Ejemplo

```
curl -X POST 'http://127.0.0.1:3000/api/v1/clients' \
-H 'Content-Type: application/json' \
--data-raw '{
    "client": {
        "username": "martinc",
        "password": "12345678",
        "password_confirmation": "12345678",
        "first_name": "Martín",
        "last_name": "Carrion"
    }
}'
```

### Respuesta exitosa

```
201 CREATED
{
    "client": {
        "username": "martinc",
        "password": "12345678",
        "password_confirmation": "12345678",
        "first_name": "Martín",
        "last_name": "Carrion"
    }
}
```

### Respuesta con error

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```

```
400 BAD_REQUEST
{
    "message": {
        "password_confirmation": [
            "doesn't match Password"
        ]
    }
}
```

## <a name='login'></a> Login de cliente
[Volver al índice](#indice)

<p>Un cliente recupera un token de autorización mediante su usuario y contraseña</p>

### Ruta
```
POST /api/v1/auth/login
```
### Headers 

```
{
  Content-Type: application/json
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>username</td>
    <td>Nombre de usuario del cliente</td>
  </tr>
  <tr>
    <td>password</td>
    <td>Contraseña del cliente</td>
  </tr>
</table>

### Ejemplo

```
curl -X POST 'http://127.0.0.1:3000/api/v1/auth/login' \
-H 'Content-Type: application/json' \
--data-raw '{
    "username": "martin",
    "password": "12345678"
}'
```

### Respuesta exitosa

```
200 OK
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOjEsImV4cCI6MTY3MzgzMDU1OH0.cvJ6h_LlE84TFF_DB8Tndckic8WlKTJ0J-cYs9vr70M"
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Contraseña incorrecta"
}
```

```
401 UNAUTHORIZED
{
    "message": "El cliente ingresado no existe"
}
```

## <a name='cliente-actual'></a> Cliente actual
[Volver al índice](#indice)

<p>Devuelve un cliente usando el valor del encabezado de autorización</p>

### Ruta
```
GET /api/v1/clients/current
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Ejemplo

```
curl -X GET 'http://127.0.0.1:3001/api/v1/clients/current' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOjEsImV4cCI6MTY3MzkyMzc3NH0.wbdbrtk_oIiNEpzKc_0RMLF375-foPcDKf0iWx9PwJ4'
```

### Respuesta exitosa

```
200 OK
{
    "client": {
        "id": 1,
        "username": "martin",
        "password_digest": "$2a$12$hcXFmkRoR9CjOhZ4tOl.vuJRqx1VmmoXpLw1utdtygbyhaWWdUtQ.",
        "first_name": "Martin",
        "last_name": "Carrion",
        "created_at": "2023-01-09T22:26:23.566Z",
        "updated_at": "2023-01-09T22:26:23.566Z"
    }
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un cliente usando el token de autorizacion"
}
```

# <a name='solicitud-contratacion'></a> Solicitud de contratación

## <a name='crear-solicitud-contratacion'></a> Crear solicitud de contratación
[Volver al índice](#indice)

<p>Un cliente crea un solicitud de contratación a un plan especifico. Es imporante destacar que el cliente no puede crear una solicitud de contratación si ya tiene una solicitud pendiente de revisión por parte del mismo proveedor. Tampoco puede crear una solicitud si ya esta suscrito a un plan del mismo proveedor actualmente. Para poder completar esta operación, el cliente necesita un token de autorización.</p>

### Ruta
```
POST /api/v1/plans/:plan_id/subscription_requests
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Query params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>plan_id</td>
    <td>Representa el id del plan al cual el cliente quiere suscribirse</td>
  </tr>
</table>

### Ejemplo

```
curl -X POST 'http://127.0.0.1:3000/api/v1/plans/1/subscription_requests' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOjIsImV4cCI6MTY3MzgzMTQyMH0.2WBjjJR1WUYubqIvFxSpn875HcsHbD8vUXy5arIPLGw'
```

### Respuesta exitosa

```
201 CREATED
{
    "subscription_request": {
        "id": 1,
        "status": "pending",
        "client_id": 2,
        "plan_id": 1,
        "created_at": "2023-01-09T01:10:57.027Z",
        "updated_at": "2023-01-09T01:10:57.027Z"
    }
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un cliente usando el token de autorizacion"
}
```

```
404 NOT_FOUND
{
    "message": "El plan solicitado no existe"
}
```

```
400 BAD_REQUEST
{
    "message": "Usted ya posee otra solicitud de contratación pendiente de revision con este proveedor"
}
```

```
400 BAD_REQUEST
{
    "message": "Usted ya posee una suscripcion activa a un plan de este proveedor, si desea cambiar su plan, cree una solicitud de cambio de plan"
}
```

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```
## <a name='solicitud-contratacion-cliente'></a> Listar solicitudes de contratación realizadas por el cliente actual
[Volver al índice](#indice)

<p>Se listan todas las solicitudes de contratación que realizó el cliente actual. Para listarlas, se necesita un token de autorización del cliente</p>

### Ruta
```
GET /api/v1/subscription_requests
```

### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Ejemplo

```
curl -X GET 'http://127.0.0.1:3001/api/v1/subscription_requests/' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOjEsImV4cCI6MTY3NDA1MDA2OX0.wp7p-Nu8cbG_Wbspqn8sVJQ7zIeWkMMjeCAiN1cpoCo'
```

### Respuesta exitosa

```
200 OK
{
    "subscription_requests": [
        {
            "id": 1,
            "status": "pending",
            "create_date": "11/01/2023",
            "plan": {
                "description": "100 mb simetrico",
                "provider": {
                    "name": "ISP3"
                }
            }
        },
        {
            "id": 2,
            "status": "rejected",
            "create_date": "11/01/2023",
            "plan": {
                "description": "50 mb simetrico",
                "provider": {
                    "name": "ISP1"
                }
            }
        },
        {
            "id": 3,
            "status": "rejected",
            "create_date": "11/01/2023",
            "plan": {
                "description": "100 mb asimetrico",
                "provider": {
                    "name": "ISP2"
                }
            }
        },
        {
            "id": 4,
            "status": "pending",
            "create_date": "11/01/2023",
            "plan": {
                "description": "10 mb simetrico",
                "provider": {
                    "name": "ISP4"
                }
            }
        },
        {
            "id": 5,
            "status": "pending",
            "create_date": "11/01/2023",
            "plan": {
                "description": "10 mb simetrico",
                "provider": {
                    "name": "ISP5"
                }
            }
        }
    ]
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un cliente usando el token de autorizacion"
}
```

## <a name='listar-solicitud-rechazada'></a> Listar solicitudes de contratación rechazadas en el ultimo mes al cliente actual
[Volver al índice](#indice)

<p>Se listan todas las solicitudes de contratación rechazadas en el ultimo mes al cliente actual. Para listarlas, se necesita un token de autorización del cliente</p>

### Ruta
```
GET /api/v1/subscription_requests/rejected_last_month
```

### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Ejemplo

```
curl -X GET 'http://127.0.0.1:3000/api/v1/subscription_requests/rejected_last_month' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOjQsImV4cCI6MTY3MzgzMjM2Nn0.5FF8-IcHyabPINqaNwQrBjdQOk2rWJG9IUnHEVxNYn4'
```

### Respuesta exitosa

```
200 OK
{
    "subscription_requests": [
        {
            "id": 4,
            "status": "rejected",
            "client_id": 4,
            "plan_id": 10,
            "created_at": "2023-01-09T01:24:51.873Z",
            "updated_at": "2023-01-09T01:24:51.873Z"
        },
        {
            "id": 5,
            "status": "rejected",
            "client_id": 4,
            "plan_id": 10,
            "created_at": "2023-01-09T01:24:51.911Z",
            "updated_at": "2023-01-09T01:24:51.911Z"
        }
    ]
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un cliente usando el token de autorizacion"
}
```

## <a name='actualizar-estado-solicitud'></a> Actualizar estado de una solicitud de contratación
[Volver al índice](#indice)

<p>El proveedor actualiza el estado de la solicitud de contratación de un cliente, pudiendola aprobar o rechazar. En caso que la apruebe, se crea una suscripción activa entre el cliente y el plan que contrató. El proveedor no puede revisar solicitudes de contratación de planes que no le pertenecen ni tampoco revisar solicitudes que ya fueron revisadas. El proveedor necesita un token de autorización para completar la operación</p>

### Ruta
```
PUT api/v1/subscription_requests/:id/update_status
PATCH api/v1/subscription_requests/:id/update_status
```

### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Query params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>subscription_request_id</td>
    <td>Representa el id de la solicitud que se va a revisar</td>
  </tr>
</table>


### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>status</td>
    <td>Representa el estado final que se va a dar a la solicitud de contratación, solo puede ser igual a "approved" o "rejected"</td>
  </tr>
</table>

### Ejemplo

```
curl -X PUT 'http://127.0.0.1:3000/api/v1/subscription_requests/9/update_status' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJwcm92aWRlcl9pZCI6MTEsImV4cCI6MTY3MzgzMzI4Mn0.hCFIIWcxTjLxvN5uDKYC48ETnJnhRxVotcNNUylPocY' \
-H 'Content-Type: application/json' \
--data-raw '{
    "status": "approved"
}'
```

### Respuesta exitosa

```
200 OK
{
    "subscription_request": {
        "status": "approved",
        "id": 9,
        "client_id": 5,
        "plan_id": 14,
        "created_at": "2023-01-09T01:39:39.636Z",
        "updated_at": "2023-01-09T01:41:46.722Z"
    }
}
```
```
200 OK
{
    "subscription_request": {
        "status": "rejected",
        "id": 9,
        "client_id": 5,
        "plan_id": 14,
        "created_at": "2023-01-09T01:39:39.636Z",
        "updated_at": "2023-01-09T01:41:46.722Z"
    }
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un proveedor usando el token de autorizacion"
}
```

```
400 BAD_REQUEST
{
    "message": "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'"
}
```

```
404 NOT_FOUND
{
    "message": "La solicitud de contrato requerida no existe"
}
```

```
400 BAD_REQUEST
{
    "message": "No puede revisar una solicitud de contratación de un plan que no le pertenece"
}
```

```
400 BAD_REQUEST
{
    "message": "La solicitud de contrato requerida ya ha sido revisada"
}
```

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```

# <a name='solicitud-cambio'></a> Solicitud de cambio de plan

## <a name='crear-solicitud-cambio'></a> Crear solicitud de cambio de plan
[Volver al índice](#indice)

<p>Una vez que el cliente tenga contratado cierto plan con un proveedor, este puede crear una solicitud de cambio de plan, para cancelar su suscripcion activa y crear una nueva a otro plan ofrecido por el mismo proveedor. El cliente no puede crear una solicitud de cambio de plan a un proveedor si ya tiene una sin revisar por parte del proveedor ni tampoco si el plan al que quiere cambiarse no forma parte del conjunto de planes que ofrece su proveedor actual. El cliente necesita un token de autorización para completar la operación correctamente</p>

### Ruta
```
POST /api/v1/subscription_change_requests
```

### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>current_subscription_id</td>
    <td>Representa el id de la suscripción activa que posee el cliente un plan</td>
  </tr>
  <tr>
    <td>new_plan_id</td>
    <td>Representa el id del plan al cual el cliente quiere cambiarse</td>
  </tr>
</table>

### Ejemplo

```
curl -X POST 'http://127.0.0.1:3000/api/v1/subscription_change_requests' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOjEsImV4cCI6MTY3Mzg4MDY5Mn0.oJ7TJuMDTDf0eNYXCeuX6YKwm7CUOmUgfGEe75iMfDM' \
-H 'Content-Type: application/json' \
--data-raw '{
    "current_subscription_id": 1,
    "new_plan_id": 4
}'
```

### Respuesta exitosa

```
201 CREATED
{
    "subscription_change_request": {
        "id": 1,
        "status": "pending",
        "subscription_id": 1,
        "plan_id": 4,
        "created_at": "2023-01-09T14:55:52.651Z",
        "updated_at": "2023-01-09T14:55:52.651Z"
    }
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un cliente usando el token de autorizacion"
}
```

```
404 NOT_FOUND
{
    "message": "No posee una suscripcion activa al plan que desea cambiar"
}
```

```
400 BAD_REQUEST
{
    "message": "Usted ya posee una solicitud de cambio pendiente de revision con el proveedor requerido"
}
```

```
404 NOT_FOUND
{
    "message": "No existe el plan al cual desea cambiarse"
}
```

```
400 BAD_REQUEST
{
    "message": "El plan al cual desea cambiarse no es del mismo proveedor de su plan actual"
}
```

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```

## <a name='actualizar-estado-cambio'></a> Actualizar estado de una solicitud de cambio de plan
[Volver al índice](#indice)

<p>El proveedor actualiza el estado de la solicitud de cambio de plan de un cliente, pudiendola aprobar o rechazar. En caso que la apruebe, se crea una suscripción activa entre el cliente y el plan al que quiere cambiarse y se desactiva la subscripción previa declarada en la misma solicitud. El proveedor no puede revisar solicitudes de cambio de planes que no le pertenecen ni tampoco revisar solicitudes que ya fueron revisadas. El proveedor necesita un token de autorización para completar la operación</p>

### Ruta
```
PUT api/v1/subscription_change_requests/:id/update_status
PATCH api/v1/subscription_change_requests/:id/update_status
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: {jwt-token}
}
```

### Query params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>subscription_change_request_id</td>
    <td>Representa el id de la solicitud que se va a revisar</td>
  </tr>
</table>


### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>status</td>
    <td>Representa el estado final que se va a dar a la solicitud de cambio de plan, solo puede ser igual a "approved" o "rejected"</td>
  </tr>
</table>

### Ejemplo

```
curl -X PUT 'http://127.0.0.1:3000/api/v1/subscription_change_requests/2/update_status' \
-H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJwcm92aWRlcl9pZCI6MSwiZXhwIjoxNjczODgyNDczfQ.VqtSXSNnPRtSAXTyFcijBcjh7cKtJ8eFlTlxwwD_O8E' \
-H 'Content-Type: application/json' \
--data-raw '{
    "status": "approved"
}'
```

### Respuesta exitosa

```
200 OK
{
    "subscription_change_request": {
        "status": "approved",
        "id": 2,
        "subscription_id": 1,
        "plan_id": 4,
        "created_at": "2023-01-09T15:20:31.214Z",
        "updated_at": "2023-01-09T15:21:27.224Z"
    }
}
```
```
200 OK
{
    "subscription_change_request": {
        "status": "rejected",
        "id": 2,
        "subscription_id": 1,
        "plan_id": 4,
        "created_at": "2023-01-09T15:20:31.214Z",
        "updated_at": "2023-01-09T15:21:27.224Z"
    }
}
```

### Respuesta con error

```
401 UNAUTHORIZED
{
    "message": "Nil JSON web token"
}
```

```
401 UNAUTHORIZED
{
    "message": "No se pudo encontrar un proveedor usando el token de autorizacion"
}
```

```
400 BAD_REQUEST
{
    "message": "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'"
}
```

```
404 NOT_FOUND
{
    "message": "La solicitud de cambio de plan requerida no existe"
}
```

```
400 BAD_REQUEST
{
    "message": "No puede revisar una solicitud de cambio de un plan que no le pertenece"
}
```

```
400 BAD_REQUEST
{
    "message": "La solicitud de cambio de plan requerida ya ha sido revisada"
}
```

```
400 BAD_REQUEST
{
  "message": {
    "{Nombre de la propiedad}": [
      {
        "error": "{Motivo de error"},
        "{Info adicional del error}",
        ...
      },
      ...
      ],
      ...
  }
}
```
