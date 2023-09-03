# cg-banking

A simple banking addon for a CivilGamers developer application.

## Configuring MySQL

I've used a Docker MySQL container for running the addon's database in development.

To run the docker container with the default creds the addon uses (configurable in `lua/cgbanking/mysql.lua`) you can use the following command:

```bash
docker run -p 3306:3306 -e MYSQL_DATABASE=cgbanking -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=rootpw mysql:latest
```

The addon will create the tables by itself, but the schema is listed below just incase something goes wrong:

```sql
CREATE TABLE IF NOT EXISTS cgbanking_balances (
    steam_id VARCHAR(32) PRIMARY KEY,
    balance DECIMAL(14, 2) NOT NULL DEFAULT 0
);
```

**NOTE -** DarkRP hasn't supported floats as money for a while now, but it would be too big of a hastle to change everything for an addon that would only be used as a code review target.
