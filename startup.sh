#!/bin/bash
set -e

CONFIG="/etc/odoo/odoo.conf"

DB_HOST=${HOST:-"odoo-community-hub-ufd0dz"}
DB_USER=${USER:-"odoo"}
DB_PASSWORD=${PASSWORD:-"5edw5jsxgauc0ito"}
DB_NAME="odoo"

echo "=== Odoo Startup ==="

# 1. Esperar a que PostgreSQL esté realmente disponible
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
    # Si la base de datos 'odoo' ni siquiera existe en Postgres, devolvemos FALSE para crearla
    print('FALSE')
")

# 3. Tomar acción según el resultado real
if [ "$DB_EXISTS" = "TRUE" ]; then
    echo "Database already initialized, skipping init."
else
    echo "Database not initialized or empty. Running --init=base (may take a few minutes)..."
    odoo -c "$CONFIG" --init=base --stop-after-init
    echo "Database initialization complete."
fi

echo "Starting Odoo server..."
exec odoo -c "$CONFIG"