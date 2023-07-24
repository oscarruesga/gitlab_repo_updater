# Usamos una imagen base con git y curl ya instalados
FROM alpine:latest

# Instalamos jq, que se necesita para el script
RUN apk add --no-cache jq git curl bash

# Creamos un directorio para nuestro script
WORKDIR /app

# Creamos un directorio para los repositorios
RUN mkdir /repos

# Copiamos nuestro script al contenedor
COPY update_repos.sh .

# Hacemos nuestro script ejecutable
RUN chmod +x update_repos.sh

# Ejecutamos el script
CMD ["./update_repos.sh"]