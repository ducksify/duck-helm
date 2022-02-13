# pg_dump-to-s3

Automatically dump and archive PostgreSQL backups to Amazon S3 or Exoscale S3 from kubernetes Pod


## Restore a backup

```bash
pg_restore -d DB_NAME -Fc --clean PATH_TO_YOUR_DB_DUMP_FILE
```