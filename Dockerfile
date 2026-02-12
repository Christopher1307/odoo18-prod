FROM odoo:18.0

USER root

# Dependencias mínimas (git para clonar OCA)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Addons OCA server-tools (branch 18.0)
RUN mkdir -p /mnt/extra-addons && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/server-tools.git /mnt/extra-addons/server-tools

USER odoo
