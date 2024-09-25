-- Предметна область (ПО) ПРОДАЖ ТЕЛЕФОНІВ:
   -- Користувачі можуть оформляти замовлення для покупки телефонів.
   -- Один користувач може оформляти декілька замовлень.
   -- В одному замовленні може бути кілька позицій телефонів у заданій кількості.

-- 1
--    users
--    orders
--    phones

--    users 1:m orders
--    orders n:m phones

-- Типи зв'язків між сутностями (таблицями):
-- stud 1 : 1 group_head
-- 1:1 one-to-one
    -- зустрічається рідше за інших
    -- => додаємо зовнішній ключ (REFERENCES) до однієї з табл. на іншу

-- CUSTOMER  1 : n ORDERS
-- brand 1 : n model
-- 1:n one-to-many
       -- (parent) головна 1:n залежна/дочірня (child)
       -- => додаємо зовнішній ключ (REFERENCES) до залежної табл. на головну

-- PHONES m : n ORDERS
-- stud m : n section
-- m:n many-to-many
       -- => вводимо дод. табл., яка посилатиметься (REFERENCES) на обидві з відношення m:n

--------------------------
-- 2 Схеми відношень:
-- users(id, fn, ln, email, ...); +
-- orders(id, date, delivery_address, status, user_id);
-- phones(id, brand, model, color, ...) +
-- phones_to_orders(id, order_id, phone_id, quantity)

-- 3:
--    id->model, model->brand (табличка або перерахування)
--    phones(id, model, brand_id, color, ...) m:1 brands(id, brand)

---------------------------------------------------
-- 4:
-- Спочатку створюються головні таблиці, потім залежні
-- Видаляються в зворотньому порядку

DROP DATABASE phones_sales;
CREATE DATABASE phones_sales;

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

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  email VARCHAR(64) CHECK (email <> ''),
  tel CHAR(13) NOT NULL UNIQUE CHECK (tel LIKE '+%')
);

INSERT INTO users (first_name, last_name, email, tel) 
VALUES
    ('John', 'Doe', 'test1@mail', '+380671234569'),
    ('Jane', 'Smith', 'test2@mail', '+380959876543'),
    ('Michael', 'Johnson', 'test3@mail', '+380665554433'),
    ('Emily', 'Davis', 'test4@mail', '+380977766554'),
    ('William', 'Brown', 'test5@mail', '+380633219876');

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP CHECK (created_at <= CURRENT_TIMESTAMP)
               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivery_address VARCHAR(200) NOT NULL, 
    status VARCHAR(20) CHECK (status IN ('pending', 'delivered')) NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) 
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

INSERT INTO orders (delivery_address, status, user_id)
VALUES
    ('вул. Соборна, 12, Запоріжжя', 'pending', 1),
    ('пр. Металургів, 15, Запоріжжя', 'delivered', 2),
    ('вул. Бурлацька, 20, Запоріжжя', 'pending', 3),
    ('вул. Космонавтів, 25, Запоріжжя', 'delivered', 4),
    ('пр. Леніна, 30, Запоріжжя', 'pending', 5),
    ('вул. Шевченка, 35, Запоріжжя', 'delivered', 1),
    ('пр. Перемоги, 40, Запоріжжя', 'pending', 2),
    ('вул. Залізнична, 45, Запоріжжя', 'delivered', 3),
    ('пр. Маяковського, 50, Запоріжжя', 'pending', 4),
    ('вул. Пушкіна, 55, Запоріжжя', 'delivered', 5);

CREATE TABLE phones_to_orders (
  id SERIAL PRIMARY KEY,
  phone_id INTEGER NOT NULL REFERENCES phones(id)
           ON UPDATE CASCADE
           ON DELETE RESTRICT,
  order_id INTEGER NOT NULL REFERENCES orders(id)
           ON UPDATE CASCADE
           ON DELETE RESTRICT,     
  quantity SMALLINT NOT NULL CHECK (quantity >= 1)             
);

-- order 4515645151
-- ph   quantity
-- 10      1
-- 5       2

INSERT INTO phones_to_orders(order_id, phone_id, quantity) 
VALUES 
    (1, 10, 1),
    (1, 5, 2),
    (2, 1, 2),
    (3, 1, 1),
    (3, 2, 1),
    (3, 3, 1),
    (4, 4, 3),
    (5, 5, 1),
    (5, 6, 1),
    (5, 7, 2);

-- [{p_id:10, q:1}, {p_id:5, q:2}]

-- Ex: Вивести інформацію про користувачів і їх замовлення (без телефонів)
SELECT *
FROM users AS u INNER JOIN orders AS o ON u.id = o.user_id
ORDER BY u.id;

-- Вивести інфо тільки про виконані замовлення із зазначенням користувача
SELECT u.first_name, u.last_name
FROM users AS u INNER JOIN orders AS o ON u.id = o.user_id
WHERE status = 'delivered'
ORDER BY u.id;

-- Task: Вивести інфо про телефони і в якій кількості їх купували
SELECT *
FROM phones p
     INNER JOIN phones_to_orders p_to_o ON p.id = p_to_o.phone_id
ORDER BY p.id;

-- Task: Вивести інфо про всі в телефони і, якщо їх купували, то в якій кількості 
SELECT *
FROM phones p
     LEFT JOIN phones_to_orders p_to_o ON p.id = p_to_o.phone_id
ORDER BY p.id;

-- Вивести інфо про куплені телефони і порахувати сумарну кількість одиниць проданих телефонів кожної моделі 
SELECT p.id, p.model, sum(pto.quantity)
FROM phones p INNER JOIN phones_to_orders pto ON p.id = pto.phone_id
GROUP BY p.id, p.model
ORDER BY sum(pto.quantity);

-- Task: Вивести кількість замовлень кожного користувача
-- 1 2
-- 2 2
-- (тільки для тих, хто має замовлення)
SELECT u.first_name, u.last_name, COUNT(o.id) AS order_count
FROM users u
     INNER JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.first_name, u.last_name
ORDER BY order_count DESC;
-- (для всих: і хто має замовлення, і хте не має)
SELECT u.first_name, u.last_name, COALESCE(COUNT(o.id), 0) AS order_count
FROM users u
     LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.first_name, u.last_name
ORDER BY order_count DESC;

-- Ex.: Вивести інформацію про сумарну вартість проданих телефонів
-- кожної моделі (впорядкувати)

-- 1000*2 + 1000*3 price*quantity

SELECT p.brand, p.model, sum(p.price*p_to_o.quantity)
FROM phones AS p INNER JOIN phones_to_orders AS p_to_o
     ON p.id = p_to_o.phone_id
GROUP BY p.id;

-- Відобразити який користувач який телефон купив
-- P P  IPhone X
-- P P  Huawei P30
-- T SH Huawei P30

SELECT u.first_name || ' ' || u.last_name AS customer,
       p.brand || ' ' || p.model AS phone
FROM users AS u 
    INNER JOIN orders AS o ON u.id = o.user_id
    INNER JOIN phones_to_orders AS p_to_o ON o.id = p_to_o.order_id
    INNER JOIN phones AS p ON p_to_o.phone_id = p.id;

-- Які телефони купував Michael Johnson   
SELECT u.first_name || ' ' || u.last_name AS customer,
       p.brand || ' ' || p.model AS phone
FROM users AS u 
    INNER JOIN orders AS o ON u.id = o.user_id
    INNER JOIN phones_to_orders AS p_to_o ON o.id = p_to_o.order_id
    INNER JOIN phones AS p ON p_to_o.phone_id = p.id
WHERE u.first_name = 'Michael' AND u.last_name = 'Johnson';

-- Скільки телефонів купив кожен користувач
SELECT u.first_name || ' ' || u.last_name AS customer, sum(p_to_o.quantity)
FROM users AS u 
    INNER JOIN orders AS o ON u.id = o.user_id
    INNER JOIN phones_to_orders AS p_to_o ON o.id = p_to_o.order_id 
GROUP BY u.id;

-- Відобразити користувачів, які купили більше 2 тел.
SELECT u.first_name || ' ' || u.last_name AS customer, sum(p_to_o.quantity) AS sum
FROM users AS u 
    INNER JOIN orders AS o ON u.id = o.user_id
    INNER JOIN phones_to_orders AS p_to_o ON o.id = p_to_o.order_id 
GROUP BY u.id
HAVING sum(p_to_o.quantity) > 2;

