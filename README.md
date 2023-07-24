# GitLab Repository Updater

This project includes a script to automatically update all the repositories in a GitLab Group, and a Docker image and Docker Compose configuration to run the script.

## Prerequisites

- Docker
- Docker Compose
- A GitLab account with access to the repositories you want to update.
- A personal GitLab access token. You can create one in the configuration section of your GitLab account.

## Usage

1. Clone this repository on your local machine.

```bash
git clone https://github.com/oscarruesga/gitlab_repo_updater.git
```

2. Change to the repository directory.

```bash
cd <repository_directory>.
```

3. Set the environment variables. These include:

- `GITLAB_HOST`: The URL of the GitLab instance. By default, this is `gitlab.com` for GitLab.com. If you are using a self-hosted instance of GitLab, you will need to change to the instance URL.
- GITLAB_GROUP: The name of the GitLab group containing the repositories to update.
- GITLAB_TOKEN: GitLab personal access token.
- HOST_PATH_TO_CLONE_REPOS: The path on your local machine where you want to clone the repositories.

You can set these variables in an `.env` file in the repository root directory.

```bash
echo "GITLAB_HOST=<url_of_your_gitlab_installation>" > .env
echo "GITLAB_GROUP=<your_group_name>" > .env
echo "GITLAB_TOKEN=<your_gitlab_token>" >> .env
echo "HOST_PATH_TO_CLONE_REPOS=<path_in_your_machine>" >> .env
```

4. Run Docker Compose to build and run the container.

```bash
docker-compose up --build
```

## Run interactive console with Docker Compose

To run an interactive console with Docker Compose, use the command docker-compose run followed by the name of the service and the command you want to run. In this case, to open an interactive bash console you could do the following as follows:

- From docker compose:

```bash
docker-compose run --rm updater bash
```

docker-compose run runs a command on a service.
`--rm` ensures that the container is removed after execution.
`updater` is the name of the service defined in your `docker-compose.yml` file.
`bash` is the command you want to run on the archive.
This will open an interactive bash console in the `updater` service container.

- From docker

```bash
docker run -it --name=gitlab_updater -e GITLAB_HOST=${GITLAB_HOST} -e GITLAB_GROUP=${GITLAB_GROUP} -e GITLAB_TOKEN=${GITLAB_TOKEN} -v ${HOST_PATH_TO_CLONE_REPOS}:/repos oscarruesga/gitlab_repo_updater bash
```
docker run inicia un nuevo contenedor con las opciones:
`-it` le indica a Docker que debe abrir una terminal interactiva.
`--name=gitlab_updater` da el nombre `gitlab_updater` al contenedor para que pueda ser referenciado más tarde.
`-e` establece las variables de entorno que necesita el contenedor. En este caso, `GITLAB_HOST`, `GITLAB_GROUP`, `GITLAB_TOKEN`. Donde `GITLAB_HOST` es la URL de la instancia de GitLab, `GITLAB_GROUP` es el nombre del grupo de GitLab que contiene los repositorios a actualizar y `GITLAB_TOKEN` es el token de acceso personal de GitLab.
`-v` monta un volumen en la ruta `${HOST_PATH_TO_CLONE_REPOS}` en el host local al directorio /repos del contenedor. 

## Contributions

Contributions to this project are welcome. Please open an issue to discuss what you would like to change, or make a pull request directly.

## License

This project is licensed under [MIT](https://choosealicense.com/licenses/mit/).
