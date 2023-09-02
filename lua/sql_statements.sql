-- This file exists as a reference for creating and maintaining the SQL statements

-- Use the following command to create a simple mysql server for tesitng
-- docker run -p 3306:3306 -e MYSQL_DATABASE=cgbanking -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=rootpw mysql:latest

-- Creates the banking tables
CREATE TABLE IF NOT EXISTS cgbanking_balances (
    steam_id VARCHAR(32) PRIMARY KEY,
    balance DECIMAL(14, 2) NOT NULL DEFAULT 0
);

-- Get the account balance of a user
SELECT * FROM cgbanking_balances
WHERE steam_id = ?
LIMIT 1;

-- update a player's balance
UPDATE cgbanking_balances
SET balance = ?
WHERE steam_id = ?;
