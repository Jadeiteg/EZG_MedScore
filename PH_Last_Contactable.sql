SELECT 
    calls.pap_submitted_application_id AS 'Application_ID',
    apps.process_status AS 'Status',
    CONVERT_TZ(MAX(call_end), '+00:00', '+08:00') AS 'Last_Contactable_Date'
FROM
    pap.pap_calls AS calls
    LEFT JOIN pap_submitted_applications AS apps
    ON calls.pap_submitted_application_id = apps.id
WHERE 
    calls.pap_submitted_application_id IS NOT NULL 
    AND calls.answer_time IS NOT NULL
GROUP BY 
    calls.pap_submitted_application_id
ORDER BY 
    calls.pap_submitted_application_id ASC;