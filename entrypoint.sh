#!/bin/bash
set -e

echo "Starting SQL Server..."
/opt/mssql/bin/sqlservr &
SQLSERVER_PID=$!

echo "Waiting for SQL Server to be ready..."
until /opt/mssql-tools18/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P "$MSSQL_SA_PASSWORD" \
    -No \
    -Q "SELECT 1" &>/dev/null; do
    echo "  ...not ready yet, retrying in 2s"
    sleep 2
done

echo "SQL Server is ready. Running cert.sql..."
/opt/mssql-tools18/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P "$MSSQL_SA_PASSWORD" \
    -No \
    -v DATABASE_KEY="$DATABASE_KEY" \
    -v DECRYPT_PASSWORD="$DECRYPT_PASSWORD" \
    -i /cert.sql

echo "Init complete. SQL Server is running."

# Hand control back to sqlservr so the container stays alive
wait $SQLSERVER_PID
