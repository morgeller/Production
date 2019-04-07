SELECT * FROM (

    SELECT  TIMESTAMP_MICROS(t)   server_time,
            time                  user_time,
            A.user_id,
            A.profile,
            A.village,
            event,
            LEAD(event) OVER (PARTITION BY A.user_id ORDER BY time ASC) AS followed_by_event,
            LEAD(time) OVER (PARTITION BY A.user_id ORDER BY time ASC) AS followed_by_time

    FROM    `VIKING.EVENTS_20190320` A
    JOIN    TMP.cards_send_crash_rev_users B ON A.user_id=B.user_id
    --WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    WHERE     event NOT IN ('asset_bundle_download_started','asset_bundle_download_finished','send_cards_popup_send_clicked','session_end')

)
WHERE event IN ('send_cards_popup_send_complete')
AND   followed_by_event IN ('loading_started','app_loaded')


************************************************************

SELECT COUNT(DISTINCT user_id) Users

FROM    TMP.cards_send_crash_rev
WHERE   TIMESTAMP_DIFF(followed_by_time,user_time,SECOND)<30
