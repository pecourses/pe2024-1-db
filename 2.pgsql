
-----------------------------------------------------------
-- Фільтрація (7.2.2)
-- WHERE 

-- SELECT що
-- FROM джерело
-- WHERE умова
-- ORDER BY ..
-- LIMIT .. OFFSET ..;

--------------------------------------------------------
-- Оператори порівняння (9.2)
-- >, <, >=, <=, =, <> (!=) 

SELECT *
FROM phones
WHERE brand = 'Samsung';

-- Ex.: Відібрати телефони, новіші 2022+ року випуску

SELECT *
FROM phones
WHERE release_date > '2021-12-31';
-- WHERE release_date >= '2022-01-01';

-- Ex.: Відібрати телефони не 2022 року
SELECT *
FROM phones
WHERE EXTRACT(YEAR FROM release_date) <> 2022;

--------------------------------------------------
-- Логічні оператори  (9.1)
-- AND OR NOT

-- Ex.: Відібрати телефони Xiaomi 512
SELECT * 
FROM phones
WHERE brand = 'Xiaomi' AND storage_capacity = 512;

-- Ex.: Знайти телефони з батареєю від 5000 2023 року
SELECT *
FROM phones
WHERE battery_capacity >= 5000 
      AND EXTRACT(YEAR from release_date) = 2023;

-- Ex.: Знайти телефони або з батареєю від 4500  або з екраном від 6.6      
SELECT *
FROM phones
WHERE battery_capacity >= 4500  
      OR screen_size >= 6.6;

--------------------------------------------------------------
-- Пошук за шаблоном  (9.7.1)
-- LIKE, ILIKE (регістронезалежний)

-- % - будь-яка кількість будь-яких символів (включаючи нічого)
-- _ - один будь-який символ

-- test% - test, testdsfdshf, testtest
-- test_ - test1, testa, test+, / -------! test, test01

-- grey phones
SELECT *
FROM phones 
WHERE color ILIKE '%gr_y%';

SELECT *
FROM phones 
WHERE brand ILIKE 'sony';

----------------------------------------------------------------------------------
-- Перевірка на приналежність інтервалу (діапазону) (9.2)
-- BETWEEN..AND

-- Ex.: Знайти телефони від 700 до 900
SELECT *
FROM phones 
WHERE price >= 700 AND price <= 900;
-- =
SELECT * 
FROM phones
WHERE price BETWEEN 700 AND 900;

-- Task: Знайти телефони від 2021 до 2022 року випуску
SELECT *
FROM phones
WHERE EXTRACT (YEAR FROM release_date) 
               BETWEEN 2021 AND 2022;

-- Ex.: Відобразити телефони 
-- ціною від 500 до 1100 +
-- 22+ року +
-- 1 сторінка при перегляді по 5
-- впорядковані за ціною +

SELECT *
FROM phones
WHERE price BETWEEN 500 AND 1100
      AND release_date >= '2022-01-01'
ORDER BY price
LIMIT 5;

--------------------------------------------
-- Перевірка на приналежність списку значень (7.2.2, 9.24.1, 9.24.2)
-- IN ()

-- Ex.: Знайти телефони марки Samsung або Xiaomi або Sony
SELECT *
FROM phones
WHERE brand = 'Samsung' 
      OR brand = 'Xiaomi' 
      OR brand = 'Sony';
-- =
SELECT * 
FROM phones
WHERE brand IN ('Samsung', 'Sony', 'Xiaomi');

-- Task: Телефони випущени взимку або влітку
SELECT *
FROM phones
WHERE EXTRACT(MONTH FROM release_date) 
      IN (12, 1, 2, 6, 7, 8);

-----------------------------------------------------------------
-- Порівняння з NULL (9.2)
-- IS NULL / ISNULL
-- IS NOT NULL / NOTNULL

-- = NULL
-- Ex.: відобразити телефони без заданої ціни
SELECT *
FROM phones
WHERE price IS NULL;

-- <> NULL
-- Ex.: відобразити телефони з ціною
SELECT *
FROM phones
WHERE price IS NOT NULL;

------------------------------
-- U - UPDATE
-- UPDATE phones
-- SET price = 1000;

-- Ex.: Оновити ціну для телефона з id 23
UPDATE phones
SET price = 400
WHERE id = 23
RETURNING brand, model;
-- RETURNING *;

-- SELECT *
-- FROM phones
-- WHERE id = 23;

-- Ex.: Збільшити телефонам з батареєю 5000 ціну на 10%
UPDATE phones
SET price = price * 1.1
WHERE battery_capacity >= 5000;

-- D - DELETE

-- Ex.: Видалити телефон з id 44
DELETE
FROM phones
WHERE id = 44;
-- RETURNING *

-- DML:
-- C - INSERT
-- R - SELECT (DQL)
-- U - UPDATE
-- D - DELETE

-------------------------------------------
CREATE DATABASE users;

-- column_name data_type constraints
CREATE TABLE IF NOT EXISTS users (
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INTEGER
);

INSERT INTO users
VALUES ('Test', 'Testovych', -25),
       ('Test', 'Testovych', 35),
       ('Test1', 'Testovych1', 35),
       ('Ivo', NULL, NULL);
       
SELECT * 
FROM users;       

DROP TABLE IF EXISTS users;

/* Створення таблиці (2.3, 5.1)
  * з типами даних (8)
  * з обмеженнями (5.4):
    - CHECK (умова) - обмеження-перевірка      - рівня стовпця чи таблиці
    - NOT NULL      - обмеження обов'язковості - рівня стовпця
    - UNIQUE        - обмеження унікальності   - рівня стовпця чи таблиці
    - PRIMARY KEY   - первинний ключ           - рівня стовпця чи таблиці
      (первинний ключ - стовпець або набір стовпців, які однозначно ідентифікують запис(рядок))
      (може бути один на таблицю)
      (PRIMARY KEY = UNIQUE + NOT NULL)
  * та зі значеннями за замовчуванням  (5.2)
      DEFAULT значення
*/

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(50) UNIQUE NOT NULL CHECK(email <> ''),
    tel_number CHAR(13) NOT NULL UNIQUE CHECK(tel_number LIKE '+380_________'),
    birthday DATE CHECK (birthday <= CURRENT_DATE),
    is_male BOOLEAN,
    orders_count SMALLINT CHECK(orders_count >= 0) DEFAULT 0
);

INSERT INTO users(first_name, last_name, email, tel_number, birthday, is_male)
VALUES ('Test', 'Testovych', 'mail@mail.mail', '+380123456789', '2000-01-20', TRUE);

INSERT INTO users(first_name, last_name, email, tel_number, birthday, is_male, orders_count)
VALUES ('Test', 'Testovych', 'mail1@mail.mail', '+380123456788', '2000-01-20', TRUE, 20);

INSERT INTO users(first_name, last_name, email, tel_number, birthday, is_male, orders_count)
VALUES ('Test', 'Testovych', 'mail2@mail.mail', '+380123678', '2000-01-20', TRUE, 20);

INSERT INTO users(last_name, email, tel_number, birthday, is_male, orders_count)
VALUES ('Testovych', 'mail2@mail.mail', '+380123456787', '2000-01-20', TRUE, 20);

UPDATE users
SET orders_count = -10;

-- SQL:
-- -- DDL
--      C - CREATE
--      R - 
--      U - ALTER
--      D - DROP
-- -- DML:
--      C - INSERT
--      R - SELECT (DQL)
--      U - UPDATE
--      D - DELETE


-- Ex.: Додати стовпчик для номера id-картки (паспорта)
ALTER TABLE users 
ADD COLUMN id_card CHAR(9) UNIQUE CHECK (id_card ~ '\d{9}')

UPDATE users
SET id_card = '123465789'
WHERE id = 1;

-- Task: Додати поле для паспорта-книжки AA000000
ALTER TABLE users
ADD COLUMN passport CHAR(8) UNIQUE CHECK (passport ~ '^[A-Z]{2}\d{6}$');

UPDATE users
SET passport = 'AA123456'
WHERE id = 3;
