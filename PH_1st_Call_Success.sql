SELECT 
    `pap_submitted_applications`.`id` AS `Application_ID`,
    `Pap Calls`.`pap_submitted_application_id` AS `PapCalls_Application_ID`,
    CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00') AS `Registration_Date`,
    CONVERT_TZ(`Pap Calls`.`answer_time`, '+00:00', '+08:00') AS `1st_Call_Success_Date`,
    TIME_FORMAT(TIMEDIFF(
        CONVERT_TZ(`Pap Calls`.`answer_time`, '+00:00', '+08:00'), 
        CONVERT_TZ(`pap_submitted_applications`.`created_at`, '+00:00', '+08:00')
    ), '%H:%i:%s') AS `1stCallSuccess_1stSubmission`,
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
        `pc1`.`answer_time`
    FROM `pap_calls` AS `pc1`
    WHERE `pc1`.`answer_time` IS NOT NULL
    AND `pc1`.`answer_time` = (
        SELECT MIN(`pc2`.`answer_time`) 
        FROM `pap_calls` AS `pc2`
        JOIN `pap_submitted_applications` AS `psa2` 
            ON `pc2`.`pap_submitted_application_id` = `psa2`.`id`
        WHERE `pc2`.`answer_time` IS NOT NULL
        AND `pc2`.`answer_time` > `psa2`.`created_at`
        AND `pc2`.`pap_submitted_application_id` = `pc1`.`pap_submitted_application_id`
    )
) AS `Pap Calls`
ON `pap_submitted_applications`.`id` = `Pap Calls`.`pap_submitted_application_id`;
