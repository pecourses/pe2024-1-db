
-- SQL
-- Назви розділів вказані до https://www.postgresql.org/docs/16/index.html

-- SQL - регістронезалежний (ключові слова прийнято в UPPER_CASE)
-- БД, таблиці, стовпці прийнято іменувати в snake_case
-- Великі літери, спец.символи - в подвійних лапках

-- Створення бази даних (23.2)
CREATE DATABASE phones_sales;
CREATE DATABASE "PhonesSales";

-- Видалення БД (23.5)
DROP DATABASE phones_sales;
DROP DATABASE "PhonesSales";

-- Створення таблиці
CREATE TABLE phones (
    id SERIAL PRIMARY KEY,                      -- Унікальний ідентифікатор телефону
    brand VARCHAR(50) NOT NULL,                 -- Бренд (наприклад, Apple, Samsung)
    model VARCHAR(100) NOT NULL,                -- Модель телефону
    os VARCHAR(50) NOT NULL,                    -- Операційна система (наприклад, Android, iOS)
    screen_size FLOAT NOT NULL,                 -- Розмір екрана в дюймах (наприклад, 6.5)
    ram INTEGER NOT NULL,                       -- Оперативна пам'ять (в ГБ)
    storage_capacity INTEGER NOT NULL,          -- Обсяг пам'яті (в ГБ)
    battery_capacity INTEGER NOT NULL,          -- Ємність батареї (в мАг)
    camera_megapixels FLOAT,                    -- Кількість мегапікселів у камері (наприклад, 12.5)
    price DECIMAL(10,2),                        -- Ціна телефону
    release_date DATE,                          -- Дата виходу на ринок
    color VARCHAR(30),                          -- Колір телефону
    is_dual_sim BOOLEAN DEFAULT FALSE           -- Наявність підтримки Dual SIM
);

-- Видалення таблиці (5.1)
DROP TABLE phone;

-- C - CREATE in CRUD - INSERT
-- Додавання даних до таблиці (2.4)
-- Кількість і послідовність полів мають співпадати
INSERT INTO phones(brand, model, os, screen_size, ram, storage_capacity, battery_capacity, camera_megapixels, price, release_date, color, is_dual_sim)
VALUES ('Xiaomi', 'Mi 9', 'HyperOS', 6.6, 8, 256, 5000, 100, 300, '2022-09-06', 'Yellow', TRUE);

INSERT INTO phones (brand, model, os, screen_size, ram, storage_capacity, battery_capacity, camera_megapixels, price, release_date, color, is_dual_sim)
VALUES
    ('Apple', 'iPhone 14', 'iOS', 6.1, 6, 128, 3200, 12.0, NULL, '2022-09-16', 'Silver', FALSE),
    ('Samsung', 'Galaxy S23', 'Android', 6.8, 8, 256, 4000, 50.0, 1099.99, '2023-02-17', 'Black', TRUE),
    ('Google', 'Pixel 7 Pro', 'Android', 6.7, 12, 256, 5000, 48.0, 899.99, '2022-10-06', 'White', TRUE),
    ('Xiaomi', 'Mi 11 Ultra', 'Android', 6.81, 12, 512, 5000, 50.3, 799.99, '2021-04-02', 'Ceramic Black', TRUE),
    ('Huawei', 'P50 Pro', 'Android', 6.6, 8, 256, 4360, 50.0, 999.99, '2021-07-29', 'Gold', TRUE),
    ('OnePlus', '10 Pro', 'Android', 6.7, 12, 256, 5000, 48.0, 799.99, '2022-01-11', 'Green', TRUE),
    ('Sony', 'Xperia 1 IV', 'Android', 6.5, 12, 512, 4500, 12.0, 1299.99, '2022-06-11', 'Purple', FALSE),
    ('Nokia', 'G50', 'Android', 6.82, 4, 128, 4850, 48.0, 299.99, '2021-09-22', 'Blue', TRUE),
    ('Motorola', 'Edge 30 Ultra', 'Android', 6.67, 12, 512, 4610, 200.0, 899.99, '2022-09-10', 'Stardust White', TRUE),
    ('Oppo', 'Find X5 Pro', 'Android', 6.7, 12, 256, 5000, 50.0, 1099.99, '2022-03-14', 'Black', TRUE),
    ('Apple', 'iPhone SE 2022', 'iOS', 4.7, 4, 64, 1821, 12.0, 429.99, '2022-03-18', 'Red', FALSE),
    ('Samsung', 'Galaxy Z Flip4', 'Android', 6.7, 8, 256, 3700, 12.0, NULL, '2022-08-10', 'Blue', TRUE),
    ('Google', 'Pixel 6a', 'Android', 6.1, 6, 128, 4410, 12.2, 449.99, '2022-07-21', 'Chalk', FALSE),
    ('Xiaomi', 'Redmi Note 11', 'Android', 6.43, 6, 128, 5000, 50.0, 299.99, '2022-01-26', 'Graphite Gray', TRUE),
    ('Huawei', 'Mate 40 Pro', 'Android', 6.76, 8, 256, 4400, 50.0, 1199.99, '2020-10-22', 'Mystic Silver', TRUE),
    ('OnePlus', 'Nord 2T', 'Android', 6.43, 8, 128, 4500, 50.0, 399.99, '2022-05-19', 'Gray Shadow', TRUE),
    ('Sony', 'Xperia 5 III', 'Android', 6.1, 8, 128, 4500, 12.0, NULL, '2021-08-11', 'Black', FALSE),
    ('Nokia', 'X20', 'Android', 6.67, 8, 128, 4470, 64.0, 399.99, '2021-05-06', 'Midnight Sun', TRUE),
    ('Motorola', 'Moto G200', 'Android', 6.8, 8, 128, 5000, 108.0, 499.99, '2021-11-18', 'Stellar Blue', TRUE),
    ('Oppo', 'Reno 7 Pro', 'Android', 6.55, 12, 256, 4500, 50.0, 749.99, '2021-12-03', 'Startrails Blue', TRUE);

INSERT INTO phones(brand, model, os, screen_size, ram, storage_capacity, battery_capacity, camera_megapixels, price, release_date, color)
VALUES ('sony', 'Mi 10', 'HyperOS', 6.6, 8, 256, 5000, 100, 300, '2023-09-06', 'Yellow');

-- !!! Видаляє всі дані з таблиці --
DELETE 
FROM phones;

-------------------------------------------------------------------------
-- R - READ in CRUD - SELECT
-- Запити на вибірку
-- SELECT що
-- FROM джерело;

-- * - вивести всі стовпці
SELECT *
FROM phones;

-- Проєкція - вибрати конкретні стовпці
SELECT brand, model, os, price
FROM phones;

-- Призначення псевдонімів (ім'я_стовпця/значення AS нове_ім'я)
SELECT brand, model, os, price, storage_capacity AS storage
FROM phones;

-- Використання функцій (глава 9)
SELECT brand || ' ' || model AS phone, price, 
       EXTRACT(YEAR FROM release_date) AS year
FROM phones;

-- Вивести вік телефона
SELECT brand, model, price, 
       EXTRACT(YEAR FROM age(release_date)) AS phohe_age
FROM phones;

-- Відображення різних значень DISTINCT (тобто прибрати рядки, що дублюються) (2.5)
SELECT DISTINCT brand
FROM phones;

-- ORDER BY
-- Сортування (2.5, 7.5)
-- ORDER BY _ ASC (за зростанням: за замовчуванням),
--            DESC (за спаданням: вказувати явно)
SELECT *
FROM phones
ORDER BY price DESC;

-- Ex.: впорядкувати за віком від найновішого до найстарішого
SELECT *
FROM phones
ORDER BY release_date DESC;

-- Ex.: Впорядкувати за брендом. Якщо бренд однаковий, то за моделлю
SELECT *
FROM phones
ORDER BY brand ASC, model ASC;

-- Пагінація (7.6)
-- LIMIT (скільки відобразити) OFFSET (скільки пропустити)
-- Для визначеності порядку вказуємо ORDER BY

-- Ex.: відобразити 1-шу сторінку при перегляді по 5
-- (тобто показати 5: LIMIT 5, нічого не пропускати: OFFSET 0 - по дефолту)
SELECT *
FROM phones
ORDER BY id
LIMIT 5;

-- Ex.: відобразити 2-гу сторінку при перегляді по 5
SELECT *
FROM phones
ORDER BY id
LIMIT 5 OFFSET 5;
-- OFFSET = (page - 1)*LIMIT

-- Task: відобразити 3-тю сторінку при перегляді по 4. Впорядкувати за ціною
SELECT *
FROM phones 
ORDER BY price
LIMIT 4 OFFSET 8;

-- Task: вивести найстаріший телефон
SELECT *
FROM phones
ORDER BY release_date
LIMIT 1;

-- Task: отримати кольори телефонів (DISTINCT)
SELECT DISTINCT color
FROM phones;

-- Task: відобразити тільки модель, бренд і обсяги пам'яті телефонів
SELECT brand, model, storage_capacity
FROM phones;

-- Task: відобразити модель, бренд і місяць релізу телефону
SELECT brand, model, EXTRACT(MONTH FROM release_date) AS release_month
FROM phones;

-- Вивести літеральне значення
SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;
SELECT CURRENT_TIME;
