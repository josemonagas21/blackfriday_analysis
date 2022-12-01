WITH traffic AS (
  SELECT 
      c.date,
      user_type_1 as user_type,
      -- COUNT(DISTINCT c.user_id) AS users,
      c.user_id AS users,
      c.pageview_id as pageviews,
      -- COUNT(c.pageview_id) AS pageviews,
      -- CONCAT(c.agent_id,session_index) AS session_id


FROM  `nyt-bigquery-beta-workspace.wirecutter_data.channel` c
      LEFT JOIN `nyt-bigquery-beta-workspace.wirecutter_data.user_type` ut ON ut.pageview_id = c.pageview_id
WHERE c.date BETWEEN '2022-11-24' AND '2022-11-28'
-- GROUP BY 1,2
),

clicks AS (
  SELECT  
    date(pg._pt) as date
  , pg.combined_regi_id AS users
  , pg.pageview_id AS pageview_id
  , int.module.element.name AS pclicks
FROM
  `nyt-eventtracker-prd.et.page` AS pg,
  unnest(interactions) AS int
WHERE
  1=1
  AND int.module.element.name LIKE '%outbound_product%'
  AND DATE(_pt) BETWEEN '2022-11-24' AND '2022-11-28'
  AND source_app LIKE '%wirecutter%'
-- GROUP BY 1,2,3
),
final AS (
  SELECT 
        t.date,
        user_type,
        COUNT(pclicks) AS clicks
  FROM traffic t
    LEFT JOIN clicks c ON t.pageviews = c.pageview_id
  GROUP BY 1,2)

SELECT * FROM final
WHERE user_type IS NOT NULL 
ORDER BY 1,2








