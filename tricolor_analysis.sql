CREATE TABLE active_periods (
    id_client INT,
    service VARCHAR(50),
    start_date DATE,
    end_date DATE
);

CREATE TABLE data_mart (
    id_client INT PRIMARY KEY,
    current_service VARCHAR(50),
    status BOOLEAN,   -- true = Активная, false = Неактивная
    region VARCHAR(50),
    date_from DATE,
    date_to DATE,
    type_of_equipment VARCHAR(50)
);

INSERT INTO active_periods (id_client, service, start_date, end_date) 
VALUES
(1, 'Internet', '2022-01-10', '2022-07-15'),
(1, 'TV',       '2022-08-01', '2022-12-31'),
(2, 'Internet', '2022-03-01', '2022-09-20'),
(2, 'TV',       '2021-11-01', '2022-08-05'),
(2, 'Mobile',   '2022-06-01', '2022-06-30'),
(3, 'Internet', '2022-04-15', '2022-10-01'),
(3, 'TV',       '2022-07-10', '2022-09-30'),
(4, 'Mobile',   '2022-05-01', '2022-07-01'),
(5, 'Internet', '2022-08-01', '2022-11-15'),
(6, 'TV',       '2022-01-01', '2022-03-31');

INSERT INTO data_mart (id_client, current_service, status, region, date_from, date_to, type_of_equipment) 
VALUES
(1, 'TV',       true,  'Moscow', '2022-08-01', '2022-12-31', 'Set-top box'),
(2, 'Mobile', false, 'Moscow', '2022-06-01', '2022-06-30', 'Router'),
(3, 'TV', false, 'SPB',    '2022-07-10', '2022-09-30', 'Router'),
(4, 'Mobile',   false, 'SPB',    '2022-05-01', '2022-07-01', 'Smartphone'),
(5, 'Internet', true,  'Kazan',  '2022-08-01', '2022-11-15', 'Router'),
(6, 'TV',       false, 'Moscow', '2022-01-01', '2022-03-31', 'Set-top box');


-- 1 Задача
SELECT
    type_of_equipment,
    COUNT(DISTINCT ap.id_client) AS clients_cnt
FROM active_periods AS ap
JOIN data_mart AS dm ON ap.id_client = dm.id_client
WHERE end_date BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY type_of_equipment
ORDER BY clients_cnt DESC;


-- 2 Задача
WITH finish AS (
    SELECT
        id_client,
        service,
        end_date,
        ROW_NUMBER() OVER (PARTITION BY id_client ORDER BY end_date DESC) AS rnk
    FROM active_periods
    WHERE end_date < NOW()
)
SELECT
    id_client,
    service,
    end_date
FROM finish
WHERE rnk = 1;


