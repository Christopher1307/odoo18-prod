FROM odoo:18.0

USER root

# Copiamos los addons que van en el repo
COPY ./extra-addons /mnt/extra-addons

# Permisos
RUN chown -R odoo:odoo /mnt/extra-addons

USER odoo
