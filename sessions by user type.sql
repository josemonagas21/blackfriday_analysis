- SESSIONS BY USER TYPE 

WITH traffic AS (
  SELECT 
      c.date,
      user_type_1,
      -- COUNT(DISTINCT c.user_id) AS users,
      -- COUNT(c.pageview_id) AS pageviews,
      CONCAT(c.agent_id,session_index) AS session_id


FROM  `nyt-bigquery-beta-workspace.wirecutter_data.channel` c
      LEFT JOIN `nyt-bigquery-beta-workspace.wirecutter_data.user_type` ut ON ut.pageview_id = c.pageview_id
WHERE c.date BETWEEN '2021-11-25' AND '2021-11-29'
-- GROUP BY 1,2
),

session AS (
  SELECT 
      date,
      user_type_1,
      COUNT(DISTINCT session_id) AS sessions
  FROM traffic 
  WHERE user_type_1 IS NOT NULL
  GROUP BY 1,2
),
final AS (
  SELECT 
        user_type_1,
        MAX(
    IF
      (date= '2021-11-25',sessions,NULL)) AS Thanksgiving,
    MAX(
    IF
      (date= '2021-11-26',sessions,NULL)) AS Black_Friday,
    MAX(
    IF
      (date= '2021-11-27',sessions,NULL)) AS Saturday,
    MAX(
    IF
      (date= '2021-11-28',sessions,NULL)) AS Sunday,
    MAX(
    IF
      (date='2021-11-29',sessions,NULL)) AS Cyber_Monday
  FROM
    session
  GROUP BY
    1 )
SELECT 
      user_type_1,
      Thanksgiving,
      Black_Friday,
      Saturday,
      Sunday,
      Cyber_Monday
  FROM
    final
  ORDER BY 1



