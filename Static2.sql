

SELECT  user_id
FROM   `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY`
WHERE   server_time >= '2019-04-03 09:30:00.000 UTC'
AND     profile='3_5_fband_Static2'
AND     event <> 'build_pay3'
GROUP BY 1

--Destination table: hallowed-forge-577:TMP.static_rev

************************************************************

SELECT *
FROM (

    SELECT  A.user_id,
            A.profile,
            A.country_code,
            ROW_NUMBER() OVER (Partition by A.user_id order by A.server_time DESC,A.time DESC) rownum
    FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY   A
    JOIN    TMP.static_rev                                        B ON A.user_id=B.user_id
    WHERE   server_time >= '2019-04-03 09:00:00.000 UTC'
    AND     event <> 'build_pay3'
    AND     profile IS NOT NULL
    )
    WHERE rownum = 1