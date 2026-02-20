# Jupyter + PyScript Container

This image bundles Jupyter Notebook/Lab, PyScript tooling, the `python-lsp-server`, and the `homeassistant-stubs` and `voluptuous` packages so you can prototype Home Assistant automations with type hints inside notebooks.

## Build

```powershell
# from this folder
docker build -t dbwalker/jupyter-pyscript:latest .
```

## Push to a registry (Docker Hub)

```powershell
# If `docker login` succeeds instantly, you might already have cached credentials.
# If you get `insufficient_scope` on push, do a clean login:
docker logout
docker login -u dbwalker

# Build/tag (if you didn't already)
docker build -t dbwalker/jupyter-pyscript:latest .

# Push
docker push dbwalker/jupyter-pyscript:latest
```

Notes:

- Ensure `dbwalker` is your **Docker Hub** username/namespace.
- Create the `jupyter-pyscript` repository on Docker Hub first if your account/org requires it.
- If you have 2FA enabled, use a Docker Hub Personal Access Token as the password.

## Run with Docker Compose (recommended)

```powershell
# optional: create .env for token/password settings
Copy-Item .env.example .env

# required for pyscript kernel: add your Home Assistant settings + token
Copy-Item .\pyscript\pyscript.conf.example .\pyscript\pyscript.conf

# start in background
docker compose up --build -d
```

This setup mounts:

- `./notebooks` -> `/home/jovyan/work` (your notebooks)
- `./jupyter-data` -> `/home/jovyan/.local/share/jupyter` (Jupyter user data)
- `./pyscript/pyscript.conf` -> `/usr/local/share/jupyter/kernels/pyscript/pyscript.conf` (Home Assistant connection + token)

Then open `http://localhost:8888` in your browser.

By default, authentication is enabled (Jupyter's built-in random token). To view it:

```powershell
docker compose logs jupyter
```

Stop the stack with:

```powershell
docker compose down
```

## Run with Docker

```powershell
# map port 8888 and mount your notebooks directory
docker run --rm -it -p 8888:8888 -v ${PWD}/notebooks:/home/jovyan/work -v ${PWD}/jupyter-data:/home/jovyan/.local/share/jupyter -v ${PWD}/pyscript/pyscript.conf:/usr/local/share/jupyter/kernels/pyscript/pyscript.conf:ro jupyter-pyscript
```

Then open `http://localhost:8888` in your browser.

By default, authentication is enabled (Jupyter's built-in random token). To view it from logs:

```powershell
docker logs <container-id>
```

To set your own token at runtime:

```powershell
docker run --rm -it -p 8888:8888 -e JUPYTER_TOKEN=mytoken jupyter-pyscript
```

To use a password, pass a **hashed** value (recommended):

```powershell
# generate hash
python -c "from jupyter_server.auth import passwd; print(passwd())"

# run container with hashed password
docker run --rm -it -p 8888:8888 -e JUPYTER_PASSWORD='<paste-hash>' jupyter-pyscript
```

Only disable auth intentionally (local trusted machine only):

```powershell
docker run --rm -it -p 8888:8888 -e JUPYTER_TOKEN='' -e JUPYTER_PASSWORD='' jupyter-pyscript
```

## Customizing

- Add more pip packages by editing `requirements.txt` and rebuilding.
- Change the default command (Notebook vs Lab) by tweaking the `CMD` line in `Dockerfile`.
- Persist notebooks by binding a host directory to `/home/jovyan/work`.
- Edit `pyscript/pyscript.conf` to point to your Home Assistant host, URL, and long-lived token.
