PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE
);

INSERT INTO users (username, email) VALUES ('Şüheda Mazlum', 'shd.mzlm@gmail.com');
INSERT INTO users (username, email) VALUES ('Melek Bartu', 'bartumlk@gmail.com');
INSERT INTO users (username, email) VALUES ('Arif Yılmaz', 'arifyilmaz@gmail.com');

SELECT * FROM users;

UPDATE users SET email = 'arif1yilmaz@gmail.com' WHERE id = 3;

DELETE FROM users WHERE id = 1; 

SELECT * FROM users;
