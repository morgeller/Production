SELECT  EXTRACT(YEAR FROM CAST(Date AS DATE)) Year,
        EXTRACT(MONTH FROM CAST(Date AS DATE)) Month,
        CASE WHEN village<OpenVillage THEN 1 ELSE 0 END Ind,
        COUNT(DISTINCT user_id) Users,
        COUNT(*)                Cards
FROM    `VIKING.Cards_*`  A
JOIN    `DIM.Cards`       B ON A.card_id=B.card_id
WHERE   _TABLE_SUFFIX >= '20170101'
AND     event = 'card_collected'
GROUP BY 1,2,3
