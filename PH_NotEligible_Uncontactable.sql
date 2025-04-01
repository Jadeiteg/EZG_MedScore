SELECT app.id 
FROM pap.pap_submitted_applications app
LEFT JOIN pap_admin_actions adm
ON app.id = adm.object_id
WHERE adm.log LIKE '%Not eligible%' OR adm.log LIKE '%Uncontactable%'
GROUP BY app.id
HAVING SUM(CASE WHEN adm.log LIKE '%Not eligible%' THEN 1 ELSE 0 END) > 0
   AND SUM(CASE WHEN adm.log LIKE '%Uncontactable%' THEN 1 ELSE 0 END) > 0
ORDER BY app.id;