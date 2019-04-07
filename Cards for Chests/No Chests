


SELECT  cast(server_time as date) date,
        user_id,
        count(distinct case when event = 'event_cards_for_chests_exchange_cards_server_success' then c end)   cards_for_chests_success,
        count(distinct case when event = 'chest_found' and source= 'cards for chests' then c end)             chest_found
FROM    `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY`
WHERE   server_time >= '2019-03-29' --AND server_time < '2019-03-30'
AND     ((event = 'event_cards_for_chests_exchange_cards_server_success') OR (event = 'chest_found' AND source= 'cards for chests'))
GROUP BY 1,2

---Destination table: hallowed-forge-577:TMP.cards_for_chests_bug_check



select * from (

SELECT  cast(server_time as date) date,
        user_id,
        profile,
        village,
        JSON_EXTRACT_SCALAR(c,'$.chestType') chestType,
        count(distinct case when event = 'event_cards_for_chests_exchange_cards_server_success' then c end)   cards_for_chests_success,
        count(distinct case when event = 'chest_found' and source= 'cards for chests' then c end)             chest_found
FROM    `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY`
WHERE   server_time >= '2019-03-29' --AND server_time < '2019-03-30'
AND     user_id = 'rof4__cjpc01j9w053b92k0dq9xw06q'
AND     event IN ('event_cards_for_chests_exchange_cards_server_success','chest_found')
GROUP BY 1,2,3,4,5
)
where cards_for_chests_success>chest_found

---Destination table: hallowed-forge-577:TMP.cards_for_chests_bug_check



SELECT  date,
        case when cards_for_chests_success>chest_found then 1 else 0 end bug,
        count(*),
        sum(cards_for_chests_success-chest_found) missin_chest
FROM    TMP.cards_for_chests_bug_check
GROUP BY 1,2
