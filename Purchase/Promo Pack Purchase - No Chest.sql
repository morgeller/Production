SELECT  date,
        case when purchases>chests then 1 else 0 end bug,
        sum(purchases)            purchases,
        sum(chests)               chests,
        count(distinct user_id)   users


FROM (

SELECT  A.user_id,
        A.date,
        IFNULL(A.purchases,0) purchases,
        IFNULL(B.chests,0)    chests

FROM (

        SELECT  cast(timestamp as date) date,
                user_id,
                count(*) purchases
        FROM    `Finance.InApp_*`
        WHERE   chests>0
        AND     _TABLE_SUFFIX >= '20190101'
        GROUP BY 1,2
        ) A
        
LEFT JOIN 
            (
        SELECT  cast(DATE as date) date,
                user_id,
                count(*) chests
        FROM    `VIKING.Cards_*`
        WHERE   event = 'chest_found'
        AND     source = 'chest_purchased'
        AND     _TABLE_SUFFIX >= '20190101'
        GROUP BY 1,2
                        
            ) B ON A.date=B.date AND A.user_id=B.user_id
            
            
          )
GROUP BY 1,2
            







SELECT  cast(TIMESTAMP_MICROS(t) as date) date,
        os,
        sum(case when event = 'in_app_purchase' and description = 'Promotions Pack v2.4' then 1 else 0 end) purchases,
        sum(case when event = 'chest_found' and source = 'chest_purchased' then 1 else 0 end) chests
FROM   `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX >= '20190330'
AND     user_id = 'A_cj796x8bf0054ncqhc8eu1yts'
GROUP BY 1,2            
