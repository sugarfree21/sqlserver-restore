-- ============================================================
-- cert.sql — sets up master key and certificates for
-- restoring an encrypted backup
-- All statements are idempotent (safe to re-run)
-- ============================================================

USE master;
GO

-- Create the database master key
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(DATABASE_KEY)';
    PRINT 'Database master key created.';
END
ELSE
    PRINT 'Database master key already exists, skipping.';
GO

-- Install the certificate
IF NOT EXISTS (SELECT name FROM sys.certificates WHERE name = 'certEncryption')
BEGIN
    CREATE CERTIFICATE certEncryption
    AUTHORIZATION dbo
    FROM FILE = '/var/opt/mssql/certs/certEncryption.cert'
    WITH PRIVATE KEY (
        FILE = '/var/opt/mssql/certs/certEncryption.pk',
        DECRYPTION BY PASSWORD = '$(DECRYPT_PASSWORD)'
    );
    PRINT 'Certificate certEncryption created.';
END
ELSE
    PRINT 'Certificate certEncryption already exists, skipping.';
GO