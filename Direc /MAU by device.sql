-- Monthly Active users by device for 2020 - 2022 (In 2020 the ET2 migration happened and we only have data after July 2020)

SELECT 
   
    DATE_TRUNC(c.date, MONTH) AS date,
    -- w.device AS device,
    -- COUNT(DISTINCT c.user_id) AS users
     
       COUNT(DISTINCT CASE WHEN w.device = 'Desktop' then c.user_id END ) AS desktop_users,
       COUNT(DISTINCT CASE WHEN w.device = 'Mobile' then c.user_id END)  AS mobile_users,
       COUNT(DISTINCT CASE WHEN w.device = 'Tablet' then c.user_id END) AS tablet_users 
        
FROM `nyt-bigquery-beta-workspace.wirecutter_data.channel` c 
LEFT JOIN `nyt-bigquery-beta-workspace.stuart_data.wc_devices` w ON w.pageview_id = c.pageview_id AND w.date = c.date 
WHERE 
    DATE_TRUNC(c.date, MONTH) BETWEEN '2020-01-01' AND '2022-11-30' 
    AND w.device IS NOT NULL 
    AND w.device IN ('Desktop','Mobile','Tablet')

GROUP BY 1
ORDER BY 1;