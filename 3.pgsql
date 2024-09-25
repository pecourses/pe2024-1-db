-- Види зв'язків між сутностями:
-- 1:1
-- 1:n
-- m:n

-- Приклади:
-- ГРУПА 1:1 СТУДЕНТИ(старости)
-- ПАЦІЄНТИ m:1 ЛІКАРІ
-- BRANDS 1:m MODELS
-- НОУТБУКИ n:m ЗАМОВЛЕННЯ
-- messages n:1 authors

CREATE DATABASE hospital;

-- головна таблиця
CREATE TABLE doctors(
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  raiting float CHECK (raiting BETWEEN 1 AND 5),
  experience SMALLINT NOT NULL CHECK (experience BETWEEN 0 AND 100) DEFAULT 0
);

-- залежна таблиця
-- id_doctor - зовнішній ключ - забезпечує посилальну цілісність, тобто
--             не можна додати пов'язану сутність (пацієнта)
--             для неіснуючої головної сутності (лікаря)
CREATE TABLE patients(
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  birthday date NOT NULL CHECK (birthday <= CURRENT_DATE),
  phone_number CHAR(13),
  id_doctor INTEGER REFERENCES doctors(id)
            ON UPDATE CASCADE
            ON DELETE SET NULL
);
-- дія - RESTRICT/NO ACTION, CASCADE, SET NULL/SET DEFAULT 
-- ON DELETE дія
-- ON UPDATE дія
-- де "дія" - це яка має бути реакція, якщо ми намагаємося видалити/оновити комірку головної таблички, 
-- на яку посилаються рядки в іншій (залежній) таблиці
-- тобто що має зробити СУБД, якщо пробувати оновити/видалити рядок в головній таблиці, 
--       якщо у нього є пов'язані рядки (у лікаря є пацієнти)

INSERT INTO doctors (first_name, middle_name, last_name, raiting, experience)
VALUES
  ('Іван', 'Петрович', 'Коваль', 4.8, 15),
  ('Марія', 'Іванівна', 'Сидоренко', 4.2, 8),
  ('Олег', 'Миколайович', 'Федоров', 3.9, 20);

INSERT INTO patients(first_name, middle_name, last_name, birthday, phone_number, id_doctor)
VALUES ('Test','Testovych', 'Testovych', '2000-12-01', '+380987654321', NULL);

-- ON UPDATE CASCADE - оновили id лікаря - оновиться id_doctor
UPDATE doctors
SET id = 100
WHERE id = 1;

--  ON DELETE SET NULL - видаляємо лікаря - прибрати лікаря у його пацієнтів: id_doctor = NULL
DELETE
FROM doctors
WHERE id = 100;

INSERT INTO doctors (first_name, middle_name, last_name, raiting, experience)
VALUES
  ('Ivan', 'Petrovych', 'Koval', 4.8, 15),
  ('Maria', 'Ivanivna', 'Sydorenko', 4.2, 8);

INSERT INTO doctors (first_name, middle_name, last_name, raiting, experience)
VALUES
  ('Ivan', 'Petrovych', 'Kovalenko', 4.0, 1);

INSERT INTO patients (first_name, middle_name, last_name, birthday, phone_number, id_doctor)
VALUES
  ('Петро', 'Іванович', 'Захарченко', '1985-02-15', '0951234567', 2),
  ('Оксана', 'Михайлівна', 'Ковальчук', '1990-07-28', '0968765432', 3),
  ('Андрій', 'Сергійович', 'Шевченко', '1975-11-10', '0973210987', 4),
  ('Марія', 'Олексіївна', 'Ткаченко', '1992-04-03', '0937896543', 5),
  ('Ігор', 'Васильович', 'Костенко', '1988-09-18', '0982345678', 2);

-- INNER JOIN (Внутрішнє з'єднання)
-- (беремо з обох таблиць тільки ті рідки, яким є відповідні в другій таблиці)
-- Відобразити докторів з їх пацієнтами
SELECT *
FROM doctors INNER JOIN patients ON doctors.id = patients.id_doctor
ORDER BY doctors.id;

-- Відобразити докторів з їх пацієнтами, впорядкувавши докторів по id
SELECT *
FROM doctors AS d INNER JOIN patients AS p ON d.id = p.id_doctor
ORDER BY d.id;

-- Знайти лікарів, які мають пацієнтів віком 38+ років
SELECT d.first_name, d.last_name
FROM doctors AS d INNER JOIN patients AS p ON d.id = p.id_doctor
WHERE EXTRACT(YEAR FROM age(p.birthday)) >= 38; 

-- Знайти лікаря у Захарченка Петра
SELECT d.first_name, d.middle_name, d.last_name
FROM doctors as d
     INNER JOIN patients ON d.id = patients.id_doctor
WHERE patients.first_name = 'Петро' AND patients.last_name = 'Захарченко';

-- LEFT JOIN 
-- (беремо з лівої таблиці всі рідки, і дописуємо відповідно ім з правої, якщо вони існують)
SELECT *
FROM patients AS p LEFT JOIN doctors AS d ON p.id_doctor = d.id
WHERE d.id IS NULL;

-- ===
-- SELECT *
-- FROM patients 
-- WHERE id_doctor IS NULL;
-- (якщо для запиту достатньо використати лише одну таблицю, то з'єднань не потрібно)

-- Знайти лікарів, які не міють пацієнтів
SELECT d.first_name, d.middle_name, d.last_name
FROM doctors d
    LEFT JOIN patients p ON d.id = p.id_doctor
WHERE p.id IS NULL;

-- RIGHT JOIN 
-- (беремо з правої таблиці всі рідки, і дописуємо відповідно ім з лівої, якщо вони існують)
-- doctors d LEFT JOIN patients p ON d.id = p.id_doctor 
-- ===
-- patients p RIGHT JOIN doctors d ON d.id = p.id_doctor 
-- тобто ліве і праві з'єднання джеркальні

-- FULL OUTER JOIN 
-- (беремо з обох таблиць всі рядки. якщо відповідні з іншої таблиці не існують, то комірки заповнюються NULL)

-- Знайти всю інфо про лікарів і пацієнтів
SELECT *
FROM doctors d
    FULL OUTER JOIN patients p ON d.id = p.id_doctor
ORDER BY d.id, p.id;

-----------------------------------------------------------

-- Прямий і зворотній інжиніринг:

-- є таблиці зі зв'язками -> схема даних (зворотній інжинірінг) - dbeaver тощо
-- при проектуванні - ERD (прямий інжинірінг)
--    ERD - Entity Relationship Diagram - діаграма "сутність-зв'язок" 

------------------------------------------------------
CREATE DATABASE plant;

-- створення нового типу даних
CREATE TYPE gender_type AS ENUM ('male', 'female', 'other');

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  first_name varchar(30) NOT NULL,
  last_name varchar(30) NOT NULL,
  email varchar(50) CHECK (email <> ''),
  birthday date NOT NULL CHECK (birthday < current_date),
  gender gender_type NOT NULL,
  salary numeric(10,2) NOT NULL DEFAULT 6000.00
);

INSERT INTO employees (first_name, last_name, email, birthday, gender, salary)
VALUES
  ('John', 'Doe', NULL, '1985-02-15', 'male', 65000.00),
  ('Jane', 'Smith', 'janesmith@example.com', '1990-07-28', 'female', 58000.00),
  ('Michael', 'Johnson', 'michaeljohnson@example.com', '1975-11-10', 'male', 72000.00),
  ('Emily', 'Davis', 'emilydavis@example.com', '1992-04-03', 'female', 60000.00),
  ('David', 'Wilson', 'davidwilson@example.com', '1988-09-18', 'male', 68000.00),
  ('Olivia', 'Miller', 'oliviamiller@example.com', '1995-05-22', 'female', 55000.00),
  ('Noah', 'Taylor', 'noahtaylor@example.com', '1980-08-10', 'male', 70000.00),
  ('Ava', 'Anderson', 'avaanderson@example.com', '1997-12-05', 'female', 57000.00),
  ('Liam', 'Lee', 'liamlee@example.com', '1982-03-17', 'male', 62000.00),
  ('Sophia', 'Clark', 'sophiaclark@example.com', '1999-01-29', 'female', 59000.00);

-- Агрегатні функції (9.21)
-- COUNT, MIN, MAX, AVG, SUM, ...

-- Порахувати загальну кількість співробітників
SELECT count(*) AS workers_count
FROM employees;

-- Підрахувати середню зарплатню співробітників
SELECT avg(salary) AS "Average salary"
FROM employees;

-- Знайти мінімальну зп
SELECT min(salary) "Min Salary"
FROM employees;

-- Обчислити середній вік працівників
SELECT avg(EXTRACT(YEAR FROM AGE(birthday))) "Average age"
FROM employees;

-- Ex.: Визначити кількість співробітників, у яких ДН в січні
SELECT count(id) AS emp_count
FROM employees
WHERE EXTRACT(MONTH FROM birthday) = 1;

-- Task: Обчислити максимальну зп жінок
SELECT max(salary) "Max Female Salary"
FROM employees
WHERE gender = 'female'

-- Групування (7.2.3)
-- GROUP BY

-- Ex: Обчислити середню зп для кожного гендера
SELECT gender, avg(salary)
FROM employees
GROUP BY gender;

-- Обчислити кількість користувачів з кожним ім'ям
SELECT first_name, count(first_name)
FROM employees
GROUP BY first_name;

--  Вивести кількість співробітників, народжених кожного місяця, 
--       * з явно вказаними email

-- 4 SELECT 3.5 aggregate_func
-- 1 FROM
-- 2 WHERE
-- 3 GROUP BY
-- 5 ORDER BY
-- 7 LIMIT 6 OFFSET

SELECT EXTRACT(MONTH FROM birthday) AS month_number, count(id)
FROM employees
WHERE email IS NOT NULL
GROUP BY month_number
ORDER BY month_number

-- Умова на групу (фільтрація груп) (7.2.3)
-- HAVING

-- Відобразити середню зп тих гендерів, для яких вона більше за 60000

SELECT avg(salary), gender
FROM employees
GROUP BY gender
HAVING avg(salary) > 60000;

-- Відобразити середню зп чоловіків

SELECT gender, AVG(salary) AS avg_salary
FROM employees
GROUP BY gender
HAVING gender = 'male';
-- 
SELECT avg(salary) man_avg_salary
FROM employees
WHERE gender = 'male'

-- Порядок виконання інструкцій:
-- 5 SELECT 3.5 aggregate_func
-- 1 FROM
-- 2 WHERE
-- 3 GROUP BY
-- 4 HAVING
-- 6 ORDER BY
-- 8 LIMIT 7 OFFSET
