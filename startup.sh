#!/bin/bash
set -e

echo "=== Odoo Startup ==="

# Variables de conexión dinámicas
DB_HOST=${HOST:-"odoo-community-hub-ufd0dz"}
DB_USER=${USER:-"odoo"}
DB_PASSWORD=${PASSWORD:-"5edw5jsxgauc0ito"}
DB_NAME="odoo"

# Ruta explícita de tus Addons
ADDONS_PATH="/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons/server-tools,/mnt/extra-addons/web-18.0,/mnt/extra-addons/dms,/mnt/extra-addons/custom"

# 1. Esperar a que PostgreSQL esté realmente disponible en la red
echo "Waiting for PostgreSQL to be ready at $DB_HOST:5432..."
until python3 -c "
import psycopg2, sys
try:
    conn = psycopg2.connect(host='$DB_HOST', user='$DB_USER', password='$DB_PASSWORD', dbname='postgres', connect_timeout=3)
    conn.close()
    sys.exit(0)
except Exception:
    sys.exit(1)
" 2>/dev/null; do
    echo "PostgreSQL is unavailable - sleeping..."
    sleep 2
done

echo "PostgreSQL is up and running!"
echo "Checking database initialization..."

# 2. Verificar de manera segura si la tabla 'base' existe
DB_EXISTS=$(python3 -c "
import psycopg2, sys
try:
    conn = psycopg2.connect(host='$DB_HOST', user='$DB_USER', password='$DB_PASSWORD', dbname='$DB_NAME')
    cur = conn.cursor()
    cur.execute(\"SELECT 1 FROM ir_module_module WHERE name='base'\")
    result = cur.fetchone()
    conn.close()
    print('TRUE' if result else 'FALSE')
except Exception as e:
    print('FALSE')
")

# 3. Ejecución forzando los parámetros por comando (Ignorando el odoo.conf problemático)
if [ "$DB_EXISTS" = "TRUE" ]; then
    echo "Database already initialized, skipping init."
else
    echo "Database not initialized or empty. Running --init=base..."
    odoo --db_host="$DB_HOST" --db_user="$DB_USER" --db_password="$DB_PASSWORD" --addons-path="$ADDONS_PATH" --init=base --stop-after-init
    echo "Database initialization complete."
fi

echo "Starting Odoo server..."
# Ejecución limpia con banderas explícitas y modo proxy activado para Dokploy
exec odoo --db_host="$DB_HOST" --db_user="$DB_USER" --db_password="$DB_PASSWORD" --addons-path="$ADDONS_PATH" --data-dir=/var/lib/odoo --proxy-mode