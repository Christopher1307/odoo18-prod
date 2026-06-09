FROM odoo:18.0

USER root

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get update -o Acquire::Retries=5 \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

# Copiar addons al contenedor
COPY ./extra-addons /mnt/extra-addons
RUN chown -R odoo:odoo /mnt/extra-addons

# --- NUEVAS LÍNEAS PARA EL STARTUP ---
COPY ./startup.sh /startup.sh
RUN chmod +x /startup.sh && chown odoo:odoo /startup.sh

USER odoo

# Forzar a que use tu script al arrancar
ENTRYPOINT ["/startup.sh"]