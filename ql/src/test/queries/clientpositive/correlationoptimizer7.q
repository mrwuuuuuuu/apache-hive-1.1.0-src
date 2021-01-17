set hive.auto.convert.join=true;
set hive.optimize.correlation=false;

-- SORT_QUERY_RESULTS

EXPLAIN
SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;


set hive.optimize.correlation=true;
EXPLAIN
SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

set hive.auto.convert.join=true;
set hive.auto.convert.join.noconditionaltask=true;
set hive.auto.convert.join.noconditionaltask.size=10000000000;

set hive.optimize.correlation=false;
-- Without correlation optimizer, we will have 3 MR jobs.
-- The first one is a MapJoin and Aggregation (in the Reduce Phase).
-- The second one is another MapJoin. The third one is for ordering.
-- With the correlation optimizer, right now, we have
-- 1 MR jobs, evaluatinf the sub-query xx and the join of
-- xx and yy.
EXPLAIN
SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

set hive.optimize.correlation=true;
EXPLAIN
SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

SELECT xx.key, xx.cnt, yy.key, yy.value
FROM (SELECT x.key AS key, count(1) AS cnt
      FROM src x JOIN src1 y ON (x.key = y.key)
      GROUP BY x.key) xx
JOIN src1 yy
ON xx.key=yy.key;

