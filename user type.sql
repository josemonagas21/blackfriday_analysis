-- USER TYPE AND PAGEVIEWS 

WITH users AS (
  SELECT 
      c.date,
      user_type_1,
      COUNT(DISTINCT c.user_id) AS users,
      COUNT(c.pageview_id) AS pageviews,


FROM  `nyt-bigquery-beta-workspace.wirecutter_data.channel` c
      LEFT JOIN `nyt-bigquery-beta-workspace.wirecutter_data.user_type` ut ON ut.pageview_id = c.pageview_id
WHERE c.date BETWEEN '2022-11-24' AND '2022-11-28'
GROUP BY 1,2
)
SELECT * 
FROM users
WHERE user_type_1 IS NOT NULL 
ORDER BY 1,2