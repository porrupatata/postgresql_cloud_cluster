#!/bin/bash
set -e
#chown pgbouncer:pgbouncer pgbouncer.*
#chown postgres:postgres server.*
chown postgres:postgres pgbouncer.*

#!/bin/bash
set -e
# pgbouncer
mv pgbouncer.* /etc/pgbouncer
cp root.crt /etc/pgbouncer

# postgres
#mv server.* /var/lib/pgsql/13/data
#cp root.crt /var/lib/pgsql/13/data
