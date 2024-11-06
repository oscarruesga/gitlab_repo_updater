#!/bin/bash

# Modo verboso
# set -x

# Usamos las variables de entorno proporcionadas por Docker
host=$GITLAB_HOST
group=$GITLAB_GROUP
token=$GITLAB_TOKEN

# Máximo número de páginas a procesar
max_pages=10

# Número de proyectos por página
per_page=100

# Directorio base para los repositorios
base_dir="/repos"

for ((page=1; page<=max_pages; page++))
do
  # Obtener la lista de proyectos en el grupo
  repos=$(curl --header "PRIVATE-TOKEN: $token" "https://$host/api/v4/groups/$group/projects?per_page=$per_page&page=$page" | jq -r '.[] | .path_with_namespace')

  # Si no hay más repositorios, terminar el bucle
  if [ -z "$repos" ]; then
    break
  fi

  # Para cada repositorio
  for repo in $repos
  do
    echo "Procesando $repo"
    
    # Crear un directorio para el repositorio
    repo_dir="${base_dir}/${repo}"
    mkdir -p "$repo_dir"

    # Cambiamos al directorio del repositorio
    cd "$repo_dir"

    # Clonar el repositorio si no existe ya
    if [ "$(ls -A $repo_dir)" ]; then
      echo "$repo ya existe, actualizando"
      git remote set-url origin "https://oauth2:${token}@$host/${repo}.git"
      git fetch --all
      git pull
    else
      echo "Clonando $repo"
      git clone "https://oauth2:${token}@$host/${repo}.git" .
    fi

    # # Obtener todas las ramas remotas
    # remote_branches=$(git branch -r | cut -c 3- | sed 's/^origin\///')

    # # Para cada rama
    # for branch in $remote_branches
    # do
    #   # Omitir HEAD
    #   if [[ $branch == "HEAD" ]]
    #   then
    #     continue
    #   fi

    #   echo "Actualizando $branch"

    #   # Comprobar si la rama existe localmente
    #   if ! git show-ref --verify --quiet refs/heads/$branch
    #   then
    #     # Si no existe, crearla
    #     git branch $branch origin/$branch
    #   fi

    #   # Cambiar a la rama
    #   git checkout $branch

    #   # Actualizar la rama
    #   git merge origin/$branch
    # done
  done
done