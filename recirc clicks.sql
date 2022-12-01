-- Recirc clicks 

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

recirc AS (
  SELECT 
    -- DATE_TRUNC(date(_pt), MONTH) as date
  -- , pg.combined_regi_id
  date(pg._pt) as date
  , pg.pageview_id
  , COUNT(int.module.name) as recirc_clicks
FROM
  `nyt-eventtracker-prd.et.page` AS pg,
  unnest(interactions) AS int
WHERE
  DATE(_pt)  BETWEEN '2022-11-24' AND '2022-11-28'
  AND source_app LIKE '%wirecutter%'
  AND int.module.name = 'recirc_clicks'
GROUP BY 1,2),

final AS (
  SELECT 
        t.date,
        user_type,
        SUM(COALESCE(recirc_clicks,0)) AS clicks
        -- c.recirc_clicks
  FROM traffic t
    LEFT JOIN recirc c ON t.pageviews = c.pageview_id 
  GROUP BY 1,2)

SELECT * FROM final
WHERE user_type IS NOT NULL 
ORDER BY 1,2








