Tips for upgrading postgresql

# Note the current location of the postgresql bin directory
# We will use this later to pass to the pg_upgrade command
which psql | xargs ls -al
# Stop postgresql service
sudo systemctl stop postgresql
# Change to postgres user
sudo su postgres
# Start a shell with the version of postgresql you want to upgrade to
nix-shell -p postgresql_15
# Initialize the database into a folder with the version number of postgres
initdb -D /var/lib/postgresql/15
# Run pg_upgrade pointing to the old postgresql data and bin folders
pg_upgrade -d /var/lib/postgresql/14 -D /var/lib/postgresql/15 -b /nix/store/dsgziywn8ghg6g9xn7wr9q5cszjbpqng-postgresql-14.9/bin -B /nix/store/kiikardwawq1kaskvxkg468nnnq8ya81-postgresql-15.4/bin

# Modify /etc/nixos/configuration.nix to use the new postgresql version 
# and then run "sudo nixos-rebuild switch"


