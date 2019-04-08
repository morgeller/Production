SELECT *
FROM (
    SELECT  A.user_id,
            A.profile,
            A.country_code,
            LTV,
            ROW_NUMBER() OVER (Partition by A.user_id order by A.server_time DESC,A.time DESC) rownum
    FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY   A
    JOIN    `VIKING.Account`                                      B ON A.user_id=B.user_id
    WHERE   server_time >= '2019-04-01'
    AND     event <> 'build_pay3'
    AND     profile IS NOT NULL
    )
WHERE rownum = 1
AND   profile LIKE '%Static2%'
AND   LTV>=1000
