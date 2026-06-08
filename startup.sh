#!/bin/bash
set -e

CONFIG="/etc/odoo/odoo.conf"

echo "=== Odoo Startup ==="
echo "Checking database initialization..."

if python3 -c "
import psycopg2, os, sys
try:
    conn = psycopg2.connect(
        host=os.environ.get('HOST', 'odoo-community-hub-ufd0dz'),
        user=os.environ.get('USER', 'odoo'),
        password=os.environ.get('PASSWORD', '5edw5jsxgauc0ito'),
        dbname='odoo'
    )
    cur = conn.cursor()
    cur.execute(\"SELECT 1 FROM ir_module_module WHERE name='base'\")
    result = cur.fetchone()
    conn.close()
    sys.exit(0 if result else 1)
except Exception as e:
    print('Check failed:', e, file=sys.stderr)
    sys.exit(1)
" 2>/dev/null; then
    echo "Database already initialized, skipping init."
else
    echo "Database not initialized. Running --init=base (may take a few minutes)..."
    odoo -c "$CONFIG" --init=base --stop-after-init
    echo "Database initialization complete."
fi

echo "Starting Odoo server..."
exec odoo -c "$CONFIG"
