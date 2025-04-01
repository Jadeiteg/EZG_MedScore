SELECT 
    `pap_submitted_applications`.`id` AS `Application_ID`,
    `Pap Calls`.`pap_submitted_application_id` AS `PapCalls_Application_ID`,
    CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00') AS `Registration_Date`,
    CONVERT_TZ(`Pap Calls`.`answer_time`, '+00:00', '+08:00') AS `1st_Call_Date`,
    TIME_FORMAT(TIMEDIFF(
        CONVERT_TZ(`Pap Calls`.`answer_time`, '+00:00', '+08:00'), 
        CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00')
    ), '%H:%i:%s') AS `1stCall_1stSubmission`,
    CASE 
        WHEN DAYOFWEEK(CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00')) IN (1, 7) THEN 'Outside working hours'
        WHEN TIME(CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00')) NOT BETWEEN '08:00:00' AND '12:00:00'
          AND TIME(CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00')) NOT BETWEEN '13:30:00' AND '17:00:00'
        THEN 'Outside working hours'
        ELSE 'Within working hours'
    END AS `Working_Hours_Status`
FROM `pap_submitted_applications`
LEFT JOIN (
    SELECT 
        `pc1`.`pap_submitted_application_id`, 
        MIN(`pc1`.`answer_time`) AS `answer_time`
    FROM `pap_calls` AS `pc1`
    JOIN `pap_submitted_applications` AS `psa` 
        ON `pc1`.`pap_submitted_application_id` = `psa`.`id`
    WHERE `pc1`.`answer_time` IS NOT NULL
    AND `pc1`.`answer_time` > `psa`.`created_at`
    GROUP BY `pc1`.`pap_submitted_application_id`
) AS `Pap Calls`
ON `pap_submitted_applications`.`id` = `Pap Calls`.`pap_submitted_application_id`;
