SELECT * 
FROM (
    SELECT  user_id,
            MAX(CASE WHEN substr(profile,11,100)='Pool' THEN 1 ELSE 0 END) Pool,
            COUNT(DISTINCT substr(profile,11,100)) Profile_count
    FROM    `VIKING.EVENTS_20190407`   
    WHERE   event <> 'build_pay3'
    AND     profile IS NOT NULL
    GROUP BY 1
    )
WHERE Pool=1
AND   Profile_count>1
