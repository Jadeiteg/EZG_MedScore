SELECT 
    pap_submitted_application_id AS 'Application_ID',
    COUNT(*) AS 'Total_Inbound',
    COUNT(CASE WHEN answer_time IS NOT NULL THEN 1 END) AS 'Answered_Inbound',
    COUNT(CASE WHEN answer_time IS NULL THEN 1 END) AS 'Unanswered_Inbound',
    SUM(CASE WHEN answer_time IS NOT NULL THEN answer_duration ELSE 0 END) AS 'Total_Inbound_Duration(s)',
    CASE 
        WHEN COUNT(CASE WHEN answer_time IS NOT NULL THEN 1 END) > 0 
        THEN ROUND(SUM(CASE WHEN answer_time IS NOT NULL THEN answer_duration ELSE 0 END) / COUNT(CASE WHEN answer_time IS NOT NULL THEN 1 END), 2)
        ELSE 0
    END AS 'Average_Inbound_Duration(s)'
FROM
    pap.pap_calls
WHERE 
    to_internal = 1 
    AND pap_submitted_application_id IS NOT NULL
GROUP BY 
    pap_submitted_application_id
ORDER BY 
    pap_submitted_application_id ASC;