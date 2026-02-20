FROM quay.io/jupyter/minimal-notebook:python-3.11

ENV JUPYTER_TOKEN="" \
    JUPYTER_PASSWORD=""

USER root

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER ${NB_USER}

WORKDIR /home/${NB_USER}/work
