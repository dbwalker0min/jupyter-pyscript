# Jupyter + PyScript Container

This image bundles Jupyter Notebook/Lab, PyScript tooling, the `python-lsp-server`, and the `homeassistant-stubs` and `voluptuous` packages so you can prototype Home Assistant automations with type hints inside notebooks.

## Build

```powershell
# from this folder
docker build -t jupyter-pyscript .
```

## Run

```powershell
# map port 8888 and mount your notebooks directory
docker run --rm -it -p 8888:8888 -v ${PWD}/notebooks:/home/jupyter/work jupyter-pyscript
```

Then open `http://localhost:8888` in your browser. Authentication is disabled by default; set `JUPYTER_TOKEN` at runtime to require one.

```powershell
docker run --rm -it -p 8888:8888 -e JUPYTER_TOKEN=mytoken jupyter-pyscript
```

## Customizing

- Add more pip packages by editing `requirements.txt` and rebuilding.
- Change the default command (Notebook vs Lab) by tweaking the `CMD` line in `Dockerfile`.
- Persist notebooks by binding a host directory to `/home/jupyter/work`.
