FROM odoo:18.0

USER root

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Copiar addons al contenedor para despliegue en Dokploy
COPY ./extra-addons /mnt/extra-addons
RUN chown -R odoo:odoo /mnt/extra-addons

USER odoo
