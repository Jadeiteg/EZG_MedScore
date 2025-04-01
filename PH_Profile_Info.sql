SELECT distinct
profi.pap_submitted_application_id as 'Application_ID',
case when app.process_status = 'RE_APPROVAL' then 'Wait for review'
when app.process_status = 'CONFIRMED' then 'Confirmed'
when app.process_status = 'CONFIRMING' then 'Resulted'
when app.process_status = 'DOCUMENT_NEEDED' then 'Need more info'
when app.process_status = 'DUPLICATE_PROFILE' then 'Duplicate application'
when app.process_status = 'NOT_QUALIFIED_FOR_EVALUATION' then 'Not eligible'
when app.process_status ='CREATING' then 'Initializing'
end
as 'Status',
app.sub_status,
profi.id as 'Profile_ID',
case
when is_present = '1' then 'Main applicant'
else 'Relative' end as 'Profile_Object',
case 
when profi.accept_payment_status = 'AGREE_PAYMENT_SUPPORT' then 'Agree paticipate'
else 'Not participate'
end
as 'Profile_Participate',

profi.pap_relationship as 'Profile_Relationship',
profi.full_name as 'Profile_Name',
profi.phone,
profi.dob,
profi.gender as 'Profile_Sex',
profi.id_card_number as 'Profile_Government_ID',
profi.email as 'Profile_Email',
-- working state
ws.income,
ws.job as 'Profile_Occupation',

-- living bill
lb.has_insurance,
lb.loan,
lb.mortgage_loan as 'loan % unpaid',
lb.electric_bill,
lb.car_owner,
-- hospital
med.hospital,

-- address
case when adr.kind = 'PERMARNENT_RESIDENT' then 'Registered Address' 
else 'Current Address'
end as 'Kind' ,
adr.type 'Type',
adr.house_size as 'Size',
adr.city,
adr.district,
adr.ward,
adr.street,
adr.is_rent

-- child profile
/*chil.pap_profile_id as 'Chil of profile id',
chil.current_status,
chil.current_school,
chil.current_location,
chil.private_tuition_or_lessons*/


FROM pap.pap_profiles profi
left join pap_submitted_applications app on profi.pap_submitted_application_id = app.id
left join pap_working_states ws on profi.id=ws.pap_profile_id
left join pap_living_bills lb on profi.id=lb.pap_profile_id
left join pap_profile_addresses adr on profi.id = adr.pap_profile_id
left join pap_child_profiles chil on profi.id = chil.pap_profile_id
left join pap_patient_medicals med on profi.id = med.pap_profile_id

where adr.kind != 'PERMARNENT_RESIDENT'
;