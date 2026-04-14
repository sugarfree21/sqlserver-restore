FROM --platform=linux/amd64 mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y

USER root

# Copy init files
COPY cert.sql /cert.sql
COPY restore.sql /restore.sql
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy certificates to a dedicated directory
RUN mkdir -p /var/opt/mssql/certs
COPY *.cert /var/opt/mssql/certs/certEncryption.cert
COPY *.pk /var/opt/mssql/certs/certEncryption.pk
RUN chmod 600 /var/opt/mssql/certs/*

EXPOSE 1433

CMD ["/entrypoint.sh"]