-- Saved products and articles 

-- select * from `nyt-bigquery-beta-workspace.ariel_data.save_content_daily`  limit 10

SELECT 
      date,
      SUM(CASE WHEN content_type = 'article' THEN 1 END) AS saved_articles,
      SUM(CASE WHEN content_type = 'product' THEN 1 END) AS saved_products,

FROM `nyt-bigquery-beta-workspace.ariel_data.save_content_daily`  

WHERE save_type = 'save' AND date BETWEEN '2022-11-24' AND '2022-11-28'

GROUP BY 1
      