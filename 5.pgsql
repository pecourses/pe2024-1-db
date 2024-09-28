-- Представлення VIEW (3.2)

CREATE VIEW users_phones AS
SELECT p.*, u.first_name, u.last_name, u.email, u.tel, 
       o.created_at, o.delivery_address, o.status, o.user_id, 
       ptoo.order_id, ptoo.quantity
FROM users AS u INNER JOIN orders AS o ON u.id = o.user_id
     INNER JOIN phones_to_orders AS ptoo ON o.id = ptoo.order_id
     INNER JOIN phones AS p ON ptoo.phone_id = p.id;

SELECT *
FROM users_phones;

-- Ex.: Які телефони купував Michael Johnson   
SELECT first_name || ' ' || last_name AS customer,
       brand || ' ' || model AS phone
FROM users_phones
WHERE first_name = 'Michael' AND last_name = 'Johnson';

-- Task: Обчислити кількість замовлень кожного користувача

CREATE VIEW quantity_of_orders AS
SELECT u.first_name, u.last_name, u.email, u.tel, 
       o.created_at, o.delivery_address, o.status, o.user_id   
FROM users u INNER JOIN orders o ON u.id = o.user_id

SELECT first_name, last_name, count(*) AS count
FROM quantity_of_orders
GROUP BY user_id, last_name, first_name
ORDER BY count DESC;

-- DROP VIEW quantity_of_orders

------------------------------------------------------------------------
-- Умовні вирази (9.18)
-- CASE

CREATE TABLE users1(
   id SERIAL PRIMARY KEY,
   name varchar(60),
   is_male boolean
);

INSERT INTO users1 (name, is_male)
VALUES ('John Smithko', true),
       ('John Smithky', true),
       ('Anny Smithko', false),
       ('Anny Smithov', false),
       ('Anny Smith', null);

-- Ex: Вивести замість булевського значення гендера рядкове
      --  ('John Smithko', 'Male'),
      --  ('Anny Smithko', 'Female'),
      --  ('Anny Smith', 'Other');      

-- повна форма (подібна if .. else if .. else)
-- CASE WHEN умова THEN результат
--   [WHEN ...]
--   [ELSE результат]
-- END
SELECT id, name, 
       CASE 
         WHEN is_male = true THEN 'Male'
         WHEN is_male = false THEN 'Female'
         ELSE 'Other'
       END AS is_male
FROM users1;

-- коротка форма (подібна switch..case)
-- CASE вираз
--   WHEN значення THEN результат
--   [WHEN ...]
--   [ELSE результат]
-- END
SELECT name, 
  CASE is_male 
    WHEN true THEN 'Male'
    WHEN false THEN 'Female'
    ELSE 'Other'  
  END
FROM users1;    

-- Task: Вивести користувачів у вигляді
-- id name  is_male
-- 1  ***ko true
-- 2  ***ky true
-- ...
-- 5  ***** false

SELECT id, 
  CASE WHEN name LIKE '%ko' THEN '***ko'
       WHEN name LIKE '%ky' THEN '***ky'
       ELSE '*****' 
  END,
  is_male
FROM users1;

------------------------------------------------
-- Підзапити
-- 1 Скалярні (повертають 1 значення)
-- Ex: Знайти тел, дорожчі за 	Motorola	Edge 30 Ultra

SELECT *
FROM phones
WHERE price > (
    SELECT price 
    FROM phones
    WHERE brand = 'Motorola' AND model = 'Edge 30 Ultra'
)

-- Ex: Відобразити список телефонів дорожче за середній за ціною 

SELECT *
FROM phones
WHERE price > (
    SELECT avg(price)
    FROM phones
);

-- Task: Відобразити телефони, які коштують так само,
-- як і найдешевший телефон

SELECT *
FROM phones
WHERE price = (
    SELECT min(price)
    FROM phones
);

-- Task: Відібрати телефони, які зроблені того ж року, 
-- що і Samsung	Galaxy Z Flip4

SELECT *
FROM phones
WHERE EXTRACT(YEAR FROM release_date) = (
    SELECT EXTRACT(YEAR FROM release_date)
    FROM phones
    WHERE brand = 'Samsung' AND model = 'Galaxy Z Flip4'
)

-- Ex: *Відобразити інформацію про телефони, які старіші за найдорожчий Google Pixel

SELECT *
FROM phones
WHERE release_date < (
    SELECT release_date
    FROM phones
    WHERE brand = 'Google' AND price = (
        SELECT MAX(price)
        FROM phones
        WHERE brand = 'Google'
    )
)

-- Відобразити всі замовлення (основна інфа) Jane Smith
SELECT *
FROM orders
WHERE user_id = (
    SELECT id
    FROM users
    WHERE first_name = 'Jane' AND last_name = 'Smith'
);
-- або

-- корельовані підзапити (якщо їх можна уникнути, то треба уникати, 
--   оскільки вони виконуються по 1 разу для кожного рідка зовнішнього запиту)
-- звичайний підзапит виконується 1 раз
SELECT *, 
    (SELECT first_name FROM users AS u WHERE u.id = o.user_id) AS name,
    (SELECT last_name FROM users AS u WHERE u.id = o.user_id) AS surname
FROM orders AS o
WHERE o.user_id = (
    SELECT id
    FROM users
    WHERE first_name = 'Jane' AND last_name = 'Smith'
);
-- або
SELECT o.*, first_name || ' ' || last_name AS full_name
FROM orders o INNER JOIN users u ON o.user_id = u.id
WHERE first_name = 'Jane' AND last_name = 'Smith';

-------------------------------------------------------------------
-- 2 Вирази підзапитів (9.23)
-- вираз IN (підзапит) -- на відповідність до одного зі списку
-- EXISTS (підзапит) => true/false
-- вираз ANY/SOME (підзапит) порівняння хоч з одним має задовольнятися
-- вираз ALL (підзапит) порівняння з усіма має задовольнятися

--- IN -------------------------------------------------

-- Знайти телефони з такими ж батареями, як і у Моторол
SELECT *
FROM phones
WHERE battery_capacity IN (
    SELECT battery_capacity
    FROM phones
    WHERE brand = 'Motorola'  
)

-- Знайти телефони, виготовлені в ті ж роки, що і наявні мотороли
SELECT *
FROM phones
WHERE EXTRACT(YEAR FROM release_date) IN (
    SELECT EXTRACT(YEAR FROM release_date)
    FROM phones
    WHERE brand = 'Motorola'
)

---- EXISTS -------------------------------------------

-- Ex.: Відобразити інфо про телефони, які купували
SELECT * 
FROM phones
WHERE id IN (
    SELECT phone_id 
    FROM phones_to_orders
)
-- =
SELECT DISTINCT p.id, brand, model
FROM phones p INNER JOIN phones_to_orders ptoo ON p.id = ptoo.phone_id
ORDER BY p.id
-- =
SELECT *
FROM phones p
WHERE EXISTS(
    SELECT 1
    FROM phones_to_orders ptoo
    WHERE p.id = ptoo.phone_id
)

-- Task: Відобразити інфо про телефони, які не купували
SELECT *
FROM phones p
WHERE NOT EXISTS(
    SELECT 1
    FROM phones_to_orders ptoo
    WHERE p.id = ptoo.phone_id
)
--=
SELECT * 
FROM phones
WHERE id NOT IN (
    SELECT phone_id 
    FROM phones_to_orders
)
--=
SELECT *
FROM phones p LEFT JOIN phones_to_orders ptoo ON p.id = ptoo.phone_id
WHERE ptoo.id IS NULL;

---- ALL / SOME(ANY) --------------------------------------

-- Ex: Відібрати тел, які дорожчі за всіх xiaomi

SELECT *
FROM phones
WHERE price > ALL (
    SELECT price
    FROM phones
    WHERE brand = 'Xiaomi'
);

SELECT *
FROM phones
WHERE price > (
    SELECT max(price)
    FROM phones
    WHERE brand = 'Xiaomi'
);

-- Task: Відібрати тел, які дешевші за хоч одного самсунгів
SELECT *
FROM phones
WHERE price < ANY (
    SELECT price
    FROM phones
    WHERE brand = 'Samsung'
);
-- ALL >max, <min
-- ANY >min, <max
SELECT *
FROM phones
WHERE price < (
    SELECT max(price)
    FROM phones
    WHERE brand = 'Samsung'
);

-------------------------------------------
-- Поєднання запитів (7.4)

CREATE TABLE basket_a (
    a INT PRIMARY KEY,
    fruit_a VARCHAR (100) NOT NULL
);

CREATE TABLE basket_b (
    b INT PRIMARY KEY,
    fruit_b VARCHAR (100) NOT NULL
);

INSERT INTO basket_a (a, fruit_a)
VALUES
    (1, 'Apple'),
    (2, 'Orange'),
    (3, 'Banana'),
    (4, 'Cucumber');

INSERT INTO basket_b (b, fruit_b)
VALUES
    (1, 'Orange'),
    (2, 'Apple'),
    (3, 'Watermelon'),
    (4, 'Pear');

-- Об'єднання: є хоч десь (UNION)
-- Знайти всі фрукти з обох таблиць
SELECT *
FROM basket_a a FULL OUTER JOIN basket_b b ON a.fruit_a = b.fruit_b
-- Apple
-- Orange
-- Banana
-- Cucumber
-- Watermelon
-- Pear

SELECT fruit_a
FROM basket_a
UNION
SELECT fruit_b
FROM basket_b

-- Перетин: є і там, і там (INTERSECT)
-- Відобразити фрукти, які є і там, і там
SELECT *
FROM basket_a a INNER JOIN basket_b b ON a.fruit_a = b.fruit_b

SELECT fruit_a
FROM basket_a
INTERSECT
SELECT fruit_b
FROM basket_b

-- Виключення: є в першому, але нема в другому (EXCEPT)
-- Що є в а, але немає в б
SELECT fruit_a
FROM basket_a
EXCEPT
SELECT fruit_b
FROM basket_b

-- Що є в б, але немає в а
SELECT fruit_b
FROM basket_b
EXCEPT
SELECT fruit_a
FROM basket_a

-- Обрати телефони, які не купували
SELECT id
FROM phones
EXCEPT
SELECT phone_id
FROM phones_to_orders