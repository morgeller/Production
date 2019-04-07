SELECT  CAST(TIMESTAMP_MICROS(t) AS DATE) date,
        count(distinct CASE WHEN event = 'network_error' AND source = 'new_steal_target' then user_id end) bug,
        count(distinct CASE WHEN event = 'raid_start' then user_id end) raid
FROM    `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX>= '20190312'
--AND     user_id = 'rof4__cjrf2lex500n5a4lbify41opt'
AND     event IN ('network_error','raid_start')
GROUP BY 1
