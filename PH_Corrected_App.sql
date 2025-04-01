SELECT id AS 'Application_Corrected' FROM pap_submitted_applications WHERE id IN 
(SELECT pap_submitted_application_id FROM pap_profiles WHERE correct_profile_id IS NOT NULL);