FROM odoo:19.0

USER root

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get update -o Acquire::Retries=5 \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

# Copiar addons al contenedor para despliegue en Dokploy
COPY ./extra-addons /mnt/extra-addons
RUN chown -R odoo:odoo /mnt/extra-addons

USER odoo
