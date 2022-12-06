
WITH traffic AS (
  SELECT 
      c.date,
      c.pageview_id,
      user_id
      -- w.device

FROM `nyt-bigquery-beta-workspace.wirecutter_data.channel` c
-- LEFT JOIN `nyt-bigquery-beta-workspace.stuart_data.wc_devices` w ON w.pageview_id = c.pageview_id AND w.date = c.date 
WHERE c.date between '2022-10-01' and '2022-10-31'

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
  AND DATE(_pt) BETWEEN '2022-10-01' and '2022-10-31'
  AND source_app LIKE '%wirecutter%'
-- GROUP BY 1,2,3
),
behavior AS (
    SELECT
         pageview.source
        ,pageview.pageview_id
        ,pageview.channel
        ,pageview.os_name
        ,pageview.browser_name
        ,pageview.channel,
        pageview.device


    FROM  `nyt-digpipelines-prd.analyst.behavior` AS bv,
        unnest(pageviews) AS p
    WHERE DATE(_pt) BETWEEN '2022-10-01' and '2022-10-31'    AND pageview.source_app LIKE '%wirecutter%' 

)
SELECT 
    --   DATE_TRUNC(date, YEAR) AS year_2022,
      DATE_TRUNC(t.date, MONTH) AS date,
      device,
      COUNT(pclicks) AS clicks,
      COUNT(DISTINCT user_id) AS user_count,


  FROM  traffic as t  
  LEFT JOIN behavior as b ON t.pageview_id = b.pageview_id
   LEFT JOIN clicks c ON t.pageview_id = c.pageview_id
  WHERE t.date BETWEEN '2022-10-01' and '2022-10-31'
  GROUP BY 1,2
  ORDER BY 3 DESC




