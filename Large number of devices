
SELECT  user_id,
        MAX(date)                     last_seen,
        count(distinct Device_Id)     device_count,
        count(distinct case when date>= '2019-03-02' then Device_Id end) device_count_last_month,
        count(distinct case when date>= '2019-03-23' then Device_Id end) device_count_last_10_days

FROM    `VIKING.DailyAgg_*`
WHERE    Device_Id IS NOT NULL
GROUP BY 1

--Destination table: hallowed-forge-577:TMP.large_number_of_devices

******************************************************************************************************


SELECT 	CASE 	WHEN device_count<100 THEN '50_99'
				WHEN device_count<150 THEN '100_149'
				WHEN device_count<200 THEN '150_199'
				WHEN device_count<300 THEN '200_299'
				WHEN device_count<400 THEN '300_399'
				WHEN device_count<500 THEN '400_499'
				WHEN device_count<1001 THEN '500_1000'
				WHEN device_count>1000 THEN '1001+'
		ELSE 'Else' END device_count_category,
		count(*) users

FROM 	  TMP.large_number_of_devices
WHERE   last_seen >='2019-01-01'
AND     device_count>=50
GROUP BY 1

******************************************************************************************************

SELECT 	user_id,
		    last_seen,
		    device_count,
		    device_count_last_month,
		    device_count_last_10_days

FROM 	  TMP.large_number_of_devices
WHERE   last_seen >='2019-01-01'
ORDER BY device_count DESC

LIMIT 10000
