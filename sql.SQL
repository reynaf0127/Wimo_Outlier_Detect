CREATE OR REPLACE VIEW MB_Game_DB.V_DICE2_Currency_Outliers AS

WITH zscore AS(
SELECT *,
       ABS(avg_amount-mean)/sd AS z_score
FROM(
SELECT *,
       AVG(avg_amount) OVER(PARTITION BY sub_type,type) AS mean,
       STDDEV(avg_amount) OVER(PARTITION BY sub_type,type) AS sd
FROM(
SELECT D.sub_type,com_profile_rel_id,CASE WHEN amount>0 THEN 'Faucet' ELSE 'Sink' END AS type,
       SUM(amount) AS amount,SUM(amount)/COUNT(*) AS avg_amount
FROM MB_Game_DB.MGD_DICE2_CURRENCYADJ_V3_FACT A
LEFT JOIN MB_Game_DB.MGD_ObjectIdMapping_DIM B ON A.template_id = B.template_id AND B.game_id = 21
LEFT JOIN MB_Game_DB.MGD_DICE2_sku_mapping_DIM C ON C.sku = A.currency
LEFT JOIN MB_Game_DB.MGD_ObjectIdMapping_DIM D ON D.template_id = C.template_id AND D.game_id = 21
WHERE amount!=0
GROUP BY 1,2,3
ORDER BY avg_amount DESC) AS A
) AS B
)


SELECT DISTINCT com_profile_rel_id
FROM zscore
WHERE ABS(z_score)>100 AND sub_type NOT LIKE '%Shards%'

