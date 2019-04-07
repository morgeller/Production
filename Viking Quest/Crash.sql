SELECT * FROM (

    SELECT  TIMESTAMP_MICROS(t)   server_time,
            time                  user_time,
            A.user_id,
            B.profile,
            B.village,
            event,
            LEAD(event) OVER (PARTITION BY A.user_id ORDER BY time ASC) AS followed_by_event,
            LEAD(time) OVER (PARTITION BY A.user_id ORDER BY time ASC) AS followed_by_time

    FROM    `VIKING.EVENTS_20190320` A
    JOIN    TMP.viking_q_crash_rev_users B ON A.user_id=B.user_id
    --WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    WHERE     event NOT IN ('asset_bundle_download_started','asset_bundle_download_finished')

)
WHERE event IN ('event_slot_icon_clicked','event_slot_popup_got_it_clicked')
AND   followed_by_event IN ('loading_started','app_loaded')

--TMP.viking_q_crash_rev

******************************


    SELECT  user_id,
            profile,
            village
    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    AND     event IN ('event_slot_icon_clicked','event_slot_popup_got_it_clicked')
    GROUP BY 1,2,3

--TMP.viking_q_crash_rev_users

******************************


SELECT COUNT(DISTINCT user_id) Users

FROM    TMP.viking_q_crash_rev
WHERE   TIMESTAMP_DIFF(followed_by_time,user_time,SECOND)<30
