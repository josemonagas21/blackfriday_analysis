WITH traffic AS (
            
SELECT 
      c.date,
      c.pageview_id,
      user_id,
      w.device

FROM `nyt-bigquery-beta-workspace.wirecutter_data.channel` c
LEFT JOIN `nyt-bigquery-beta-workspace.stuart_data.wc_devices` w ON w.pageview_id = c.pageview_id AND w.date = c.date 
WHERE c.date between '2022-11-01' AND '2022-11-30'

),
behavior AS (
    SELECT
         pageview.source
        ,pageview.pageview_id
        ,pageview.channel
        ,pageview.os_name
        ,pageview.browser_name
        ,pageview.channel


    FROM  `nyt-digpipelines-prd.analyst.behavior` AS bv,
        unnest(pageviews) AS p
    WHERE DATE(_pt) BETWEEN '2022-11-01' AND '2022-11-30'    AND pageview.source_app LIKE '%wirecutter%' 

)
SELECT 
    --   DATE_TRUNC(date, YEAR) AS year_2022,
      DATE_TRUNC(date, MONTH) AS date,
      b.os_name as os,
      b.browser_name as browser,
      device,
      COUNT(DISTINCT user_id) AS user_count,


  FROM  traffic as t  
  LEFT JOIN behavior as b ON t.pageview_id = b.pageview_id
  WHERE date BETWEEN '2022-11-01' AND '2022-11-30'
  GROUP BY 1,2,3,4
  ORDER BY 5 DESC

