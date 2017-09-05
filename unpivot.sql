-- pivot (縦持→横持)

-- 元テーブル
CREATE TABLE `vertical` ( `id` INTEGER, `seq` INTEGER, `val` INTEGER );
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (100, 1, 1000);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (100, 2, 100);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (100, 3, 10000);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (200, 1, 2000);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (200, 2, 2);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (200, 3, 200);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (300, 2, 300);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (400, 1, 40);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (500, 1, 5);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (500, 2, 50);
INSERT INTO vertical (`id`, `seq`, `val` ) VALUES (500, 3, 500);

-- 横持ちテーブル
CREATE TABLE `horizontal` ( `id` INTEGER, `val1` INTEGER, `val2` INTEGER, `val3` INTEGER )
INSERT INTO horizontal SELECT
     id
    ,MAX(CASE seq WHEN 1 THEN val ELSE NULL END) AS val1
    ,MAX(CASE seq WHEN 2 THEN val ELSE NULL END) AS val2
    ,MAX(CASE seq WHEN 3 THEN val ELSE NULL END) AS val3
FROM
    vertical
GROUP BY
    id
;



-- unpivot (横持→縦持)

-- 元テーブル
CREATE TABLE `horizontal` ( `id` INTEGER, `val1` INTEGER, `val2` INTEGER, `val3` INTEGER )
INSERT INTO horizontal (id`, `val1`, `val2`, `val3` ) VALUES (1, 10, 100, 1000);
INSERT INTO horizontal (id`, `val1`, `val2`, `val3` ) VALUES (2, 20, 200, NULL);
INSERT INTO horizontal (id`, `val1`, `val2`, `val3` ) VALUES (3, NULL, 3000, 3000);
INSERT INTO horizontal (id`, `val1`, `val2`, `val3` ) VALUES (4, 40, 4, 4000);

-- 加工用テーブル
CREATE TABLE `pivot` ( `seq` INTEGER);
INSERT INTO pivot (seq) VALUES (1);
INSERT INTO pivot (seq) VALUES (2);
INSERT INTO pivot (seq) VALUES (3);

-- 縦持ちテーブル
CREATE TABLE `vertical` ( `id` INTEGER, `seq` INTEGER, `val` INTEGER );
INSERT INTO vertical SELECT
    A.*
FROM
(
    SELECT
         q.id
        ,p.seq
        ,CASE p.seq
            WHEN 1 THEN q.val1
            WHEN 2 THEN q.val2
            WHEN 3 THEN q.val3
        END AS val
    FROM
        horizontal AS q
    CROSS JOIN
        pivot AS p
) A
WHERE
    A.val IS NOT NULL
ORDER BY
     A.id
    ,A.seq
;



-- Copyright (c) 2017 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.
