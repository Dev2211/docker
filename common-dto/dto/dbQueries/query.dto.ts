export const queries = {
    sampleQuery: "sample text",
    getRoles:
      "select r.* from roles r join user_role ur on ur.role_id = r.roles_id where ur.user_id = $1",
    getRolesPermission:
      'SELECT "roleId", "permissionId", p."name" from role_permissions rp join permissions p on p."id" = rp."permissionId" where rp."roleId" in(select r.roles_id from roles r join user_role ur on ur.role_id = r.roles_id where ur.user_id = $1)',
    getWorkSchedule:
      'SELECT schDay."dayOfWeek", schDay."id" as scheduleDayId,schIntr."id" as scheduleTimeId,  schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."doctor_id" = $1',
    getDoctorScheduleInterval:
      'select dcday."doctor_id", dcday."dayOfWeek", dcday."doctor_key", dcint."startTime", dcint."endTime" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on dcday."id" = dcint."docConfigScheduleDayId" where dcday."doctor_key" = $1 and dcday."id" = $2  and dcint.id not in ($3)',
    insertIntoDocConfigScheduleInterval:
      'insert into doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId") values ( $1, $2, $3)',
    updateIntoDocConfigScheduleInterval:
      'update  doc_config_schedule_interval set "startTime" = $1, "endTime" = $2  where "id" = $3',
    deleteDocConfigScheduleInterval:
      'delete from doc_config_schedule_interval where "id" = $1 and "docConfigScheduleDayId" = $2',
    getDocDetails:
      'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."doctor_key" = $1',
    getDocListDetails:
      'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" join account_details ad on ad."account_key" = d."account_key" where d."account_key" = $1',
    getConfig:
      'SELECT "consultationSessionTimings","overBookingType","overBookingCount","overBookingEnabled" from doc_config where "doctor_key" = $1',
    getAppointment:
      'SELECT * FROM appointment WHERE $1 <= "appointment_date" AND "appointment_date" <= $2 AND "doctorId" = $3 order by appointment_date',
    getAppointmentOnDate:
      'SELECT * FROM appointment WHERE "appointment_date" = $1 order by appointment_date',
    getPastAppointmentsWithPagination:
      `SELECT * FROM appointment WHERE (("appointment_date" <= $2 AND "status"=$5) OR("appointment_date" <= $7 AND "startTime" <= $8 AND ("status"=$6 OR "status"= $9))) AND "patient_id" = $1 AND "is_cancel"=false order by appointment_date desc , appointment."startTime" asc limit $4 offset $3`,
      getUpcomingAppointmentsWithPagination:
      `SELECT *, 0 as "isAttenderApp" FROM appointment a WHERE ((a."appointment_date" = $7 and a."startTime" >= $8) or (a."appointment_date" >= $2)) AND a."patient_id" = $1 AND (a."status"= $5 OR a."status"= $6) AND a."is_cancel"=false union SELECT *, 1 as "isAttenderApp" FROM appointment a WHERE ((a."appointment_date" = $7 and a."startTime" >= $8) or (a."appointment_date" >= $2)) AND (a.attender_mobile = (select phone from patient_details where patient_id = $1)) AND (a."status"= $5 OR a."status"= $6) AND a."is_cancel"=false group by id order by appointment_date asc , "startTime" asc limit $4 offset $3 `,
    getAppointmentForDoctor:
      'SELECT * FROM appointment WHERE "appointment_date" = $1 AND "doctorId" = $2 AND "is_cancel"=false',
    getAppointmentForDoctorAlongWithPatientForSameDate:
      'SELECT distinct a."id" as "appointmentId",a.appointment_date as "appointmentDate", a."startTime",a."endTime",pd."patient_id" as "patientId",pd."honorific",pd."firstName", pd."lastName",pd."photo",pd."live_status" as "patientLiveStatus", a."payment_status",a."paymentoption",a."consultationmode", a."status" FROM appointment a  join patient_details pd on pd."patient_id"=a."patient_id" WHERE ((a."appointment_date" = $6) or (a."appointment_date" = $8 and a."startTime" >= $9) or (a."appointment_date" = $1 and a."startTime" <= $7)) AND a."doctorId" = $2 AND (a."status"= $3 OR a."status"= $4) AND a."consultationmode"= $5 AND a."is_cancel"=false',
    getAppointmentForDoctorAlongWithPatientForDiffDate:
      'SELECT distinct a."id" as "appointmentId",a.appointment_date as "appointmentDate", a."startTime",a."endTime",pd."patient_id" as "patientId",pd."honorific",pd."firstName", pd."lastName",pd."photo",pd."live_status" as "patientLiveStatus", a."payment_status",a."paymentoption",a."consultationmode", a."status" FROM appointment a  join patient_details pd on pd."patient_id"=a."patient_id" WHERE ((a."appointment_date" = $6 and a."startTime" >= $7) or (a."appointment_date" = $1)) AND a."doctorId" = $2 AND (a."status"= $3 OR a."status"= $4) AND a."consultationmode"= $5 AND a."is_cancel"=false',
    getPossibleListAppointmentDatesFor7Days:
      'select appointment_date from appointment  where "doctorId" = $1 and appointment_date >=  $2 group by appointment_date limit 7',
    getListOfAppointmentFromDates:
      'select * from appointment where "doctorId" = $1 and  appointment_date in $2 order by appointment_date',
    getPatientList:
      'SELECT patient."firstName", patient."lastName", patient."email", patient."dateOfBirth", patient."phone" , app.* from appointment app left join patient_details patient on app."patient_id" = patient."patient_id" where app."doctorId" = $1 order by appointment_date',
    getTimeZone: 'SELECT time_zone from doctor where "doctor_key" = $1 ',
    getAppointmentDetailsByDate: `SELECT json_agg(json_build_object('patientId',patient."id",'honorific', patient."honorific",'patientFirstName', patient."firstName",'patientLastName', patient."lastName", 'paymentId',payment."id" ,'fullyPaid', payment."payment_status",'DoctorName',doc."doctor_name",'email',doc."email",'appointmentDate',app."appointment_date",'startTime',app."startTime",'endTime',app."endTime",'bookedBy',app."created_by",'AppointmentCreated',app."createdTime",'paymentStatus',payment."payment_status",'doctorKey',doc."doctor_key",'accountKey',doc."account_key",'reportRemainder',rep."mail_remainder")) as data1 FROM appointment app left join patient_details patient on patient."patient_id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" left join doctor doc on doc."doctorId" = app."doctorId"  left JOIN report_remainder rep ON rep.id = doc.report_remainder_id WHERE app.appointment_date = $1  group by doc."account_key"`,    
    getAdminDetails:`select email, u."account_id", acc.account_key from users u join account acc on u.account_id = acc.account_id where id in(select user_id from user_role where role_id = 1 and role_id != 2 and role_id != 3 and role_id != 3 and user_id in (select id from users where account_id in (select acc.account_id from account acc where account_key=ANY($1) )))`,
    getDocReportRemainderId:`SELECT mail_remainder FROM report_remainder WHERE id=$1`,
    getDocReportRemainder:`SELECT id FROM report_remainder WHERE mail_remainder=$1`,
    getMeetingIdForValidation:`SELECT doc."doctorId",doc."doctor_name",doc.doctor_key,doc.account_key,
    patient.patient_id,patient."name",app.id,app."appointment_date",app."startTime",
    app."endTime",app."is_active",app."is_cancel",app."slotTiming",app."status",
    to_char(app."createdTime", 'DD-MM-YYYY') as createdTime,app."meeting_id", app.attender_name,app.attender_mobile,app.attender_email From appointment app
    left join doctor doc on doc."doctorId" = app."doctorId" left join patient_details patient on patient."patient_id"= app."patient_id" 
    where meeting_id=$1 AND status IN ('notCompleted','paused') AND is_active=true AND is_cancel=false AND appointment_date IN($2,$3)`,
    //Attender Detail by appointmentId if attender was already a patient
    getAttenderDetails:`Select pd.* From appointment join patient_details pd on appointment.attender_mobile = pd.phone where appointment.id=$1`,
    //to retrive appointment with start & end times
    getAvailableTime: `SELECT dcsi."startTime", dcsi."endTime", doctor_id, "dayOfWeek", dcsi."docConfigScheduleDayId"
                              from doc_config_schedule_day dcsd 
                              left join doc_config_schedule_interval dcsi on dcsi."docConfigScheduleDayId" = dcsd.id
                          where dcsd.doctor_id = $1 
                              and dcsi."startTime" notnull 
                              and dcsi."endTime" notnull`,
    getActiveAppointment: `select app."doctorId", app.appointment_date, app."startTime", app."endTime", app.is_active 
                                  from appointment app 
                                  where app.is_active = true 
                                      and app."doctorId" = $1 
                                      and app.appointment_date >= $2 
                                      and app.appointment_date  <= $3`,
  
    getAppointments:
      'SELECT * from appointment where "doctorId" = $1 and "appointment_date" = $2 and "is_cancel"=false',
    getTodayAndTomExistApp: `SELECT * FROM appointment WHERE "doctorId"= $1 AND "patient_id"=$2 AND ("appointment_date" = $3 or "appointment_date" = $4) AND "is_cancel" = false`,
    getUpcomingAppointmentsWithTimeWithPagination: `SELECT *, 0 as "isAttenderApp" FROM appointment a  WHERE ((a."appointment_date" >= $7) or
    (a."appointment_date" = $2 and a."startTime" >= $8)
    or (a."appointment_date" = $9 and a."startTime" >= $10)) AND a."patient_id" = $1 
    AND (a."status"= $5 OR a."status"= $6) AND a."is_cancel"=false union SELECT *, 1 as "isAttenderApp" FROM appointment a  WHERE ((a."appointment_date" >= $7) or
    (a."appointment_date" = $2 and a."startTime" >= $8)
    or (a."appointment_date" = $9 and a."startTime" >= $10)) AND (a.attender_mobile = (select phone from patient_details where patient_id = $1)) 
    AND (a."status"= $5 OR a."status"= $6) AND a."is_cancel"=false group by id 
    order by appointment_date asc , "startTime" asc limit $4 offset $3`,
    getUpcomingAppointmentsWithTimeCounts: `SELECT * FROM appointment a  WHERE ((a."appointment_date" >= $5) or
    (a."appointment_date" = $2 and a."startTime" >= $6)
    or (a."appointment_date" = $7 and a."startTime" <= $8)) AND (a."patient_id" = $1 or (a.attender_mobile = (select phone from patient_details where patient_id = $1))) 
    AND (a."status"= $3 OR a."status"= $4) AND a."is_cancel"=false
    order by appointment_date asc , a."startTime" asc`,
    //getAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getAppList:
      'SELECT * from appointment WHERE "doctorId" = $1 order by appointment_date',
    getPatientId: 'SELECT "time_zone" from patient_details where id = $1 ',
  
    getReport:
      'SELECT "file_name" as "fileName", "report_date" as "reportDate", "report_url" as "attachment" , "report_url" as "attachment",comments,id FROM patient_report  WHERE patient_id = $1 AND active=$4  Order by id DESC offset $2 limit $3',
    getReportWithoutLimit:
      "SELECT * FROM patient_report  WHERE patient_id = $1 AND active=$2  Order by id DESC",
    getReportWithoutLimitSearch:
      "SELECT * FROM patient_report  WHERE patient_id = $1  AND (LOWER(comments) LIKE $2 OR LOWER(file_name) LIKE $2) AND active=$3  Order by id DESC",
    getSearchReportByAppointmentId:
      'SELECT "file_name" as "fileName", "report_date" as "reportDate", "report_url" as "attachment",comments,id FROM patient_report  WHERE appointment_id = $1   AND (LOWER(comments) LIKE $4 OR LOWER(file_name) LIKE $4) AND active=$5  Order by id DESC offset $2 limit $3',
    getReportByAppointmentId:
      'SELECT "file_name" as "fileName", "report_date" as "reportDate", "report_url" as "attachment" , comments,id FROM patient_report  WHERE appointment_id = $1 AND active=$4  Order by id DESC offset $2 limit $3',
  
    getReportWithoutLimitAppointmentIdSearch:
      "SELECT * FROM patient_report  WHERE appointment_id = $1  AND (LOWER(comments) LIKE $2 OR LOWER(file_name) LIKE $2) AND active=$3  Order by id DESC",
    getReportWithAppointmentId:
      "SELECT * FROM patient_report  WHERE appointment_id = $1 AND active=$2  Order by id DESC",
    getSearchReport:
      'SELECT "file_name" as "fileName", "report_url" as "attachment" , "report_date" as "reportDate","report_url" as "attachment", comments,id FROM patient_report  WHERE patient_id = $1 AND (LOWER(comments) LIKE $4 OR LOWER(file_name) LIKE $4) AND active=$5 Order by id DESC offset $2 limit $3',
  
    getAppListForPatient:
      'SELECT * from appointment WHERE "patient_id" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getPaginationAppList:
      'SELECT * from appointment WHERE "doctorId" = $1 AND  "appointment_date" >= $2  AND "appointment_date" <= $3 order by appointment_date',
    getScheduleIntervalDays:
      'select "docConfigScheduleDayId" from doc_config_schedule_interval  where doctorkey  =  $1 group by "docConfigScheduleDayId"',
    // getAppointByDocId: 'select * from appointment where "doctorId" = $1 and appointment_date >= $2  order by appointment_date limit 7 ',
    //getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."name" as patientName, payment."id" as paymentId, payment."is_paid" as isPaid, payment."refund" FROM appointment app left join patient_details patient on patient."id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and app."appointment_date" >= $2  order by appointment_date limit 7 ',
    getAppointByDocId:
      'SELECT app.* , patient."id" as patientId, patient."honorific", patient."firstName" as "patientFirstName", patient."lastName" as "patientLastName", payment."id" as paymentId, payment."payment_status" as "fullyPaid" FROM appointment app left join patient_details patient on patient."patient_id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and appointment_date >= $2 and app."is_cancel"=false  order by appointment_date ',
    getSlots:
      'SELECT schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."dayOfWeek" = $1 and schDay."doctor_key" = $2',
    getPatient: "SELECT * FROM patient_details WHERE phone LIKE $1",
    getReports:
      'SELECT doc."doctor_name" as "doctorName", config."consultation_cost" as "consultationFee", app."slotTiming" as "slotTime", app."appointment_date" as "appointmentDate", app."startTime", app."endTime", app."consultationmode" as "consultationType", patient."name" as "patientName", patient."phone" as phone from doctor doc left join appointment app on app."doctorId"=doc."doctorId" left join patient_details patient on patient."patient_id"=app."patient_id" left join doc_config config on config."doctor_key" = doc."doctor_key" where doc."account_key" = $1 order by appointment_date limit 10 offset $2',
    getDoctorScheduleIntervalAndDay:
      'select * from doc_config_schedule_day dcsd   join doc_config_schedule_interval dcsi on dcsd.id = dcsi."docConfigScheduleDayId" where dcsd.doctor_key = $1;',
    getDoctorByName: `SELECT distinct d."doctorId", d."account_key" as "accountKey", d."doctor_key" as "doctorKey",d."speciality", d."photo",d."signature",d."number",d."first_name" as "firstName", d."last_name" as "lastName",d."registration_number" as "registrationNumber", config."consultation_cost" as fee ,config."consultationSessionTimings" as sessionTiming, CASE WHEN ac."street1" is NULL THEN '' ELSE ac."street1" END AS street,  CASE WHEN ac."city" is NULL THEN '' ELSE ac."city" END AS city ,CASE WHEN ac."state" is NULL THEN '' ELSE ac."state" END AS state ,CASE WHEN ac."pincode" is NULL THEN '' ELSE ac."pincode" END AS pincode,CASE WHEN ac."country" is NULL THEN '' ELSE  ac."country" END AS country,ac."hospital_name" as "hospitalName", d."experience" as experience FROM doctor d left join doc_config config on config."doctor_key"=d."doctor_key" left join account_details ac on ac."account_key"=d."account_key" WHERE LOWER(doctor_name) LIKE LOWER($1) or LOWER(registration_number)  LIKE LOWER($1) or LOWER(d.doctor_key) LIKE LOWER($1)`,
    getPatientDetails:
      'SELECT "patient_id", "is_token_expired", "firstName","lastName","email","dateOfBirth","email", "phone" from patient_details where patient_id = $1',
    getPatientDetailsByEmail:
      "SELECT count(*)  from patient_details where email = $1",
    changePatientTokenExpiry:
      "SELECT is_token_expired from patient_details where patient_id =$1",
    changeDoctorTokenExpiry:
      'SELECT is_token_expired from doctor where "doctorId" = $1',
    setDoctorTokenExpiry:
      'update doctor set "is_token_expired"= true where "doctorId" =$1',
    setPatientTokenExpiry:
      'update patient_details set "is_token_expired" = true where patient_id =$1',
    patientTokenExpiryFinal:
      'update patient_details set "is_token_expired" = false where patient_id =$1 ',
    doctorTokenExpiryFinal:
      'update doctor set "is_token_expired" = false where "doctorId" =$1',
  
    getHospitalByName: `SELECT "hospital_name" as "hospitalName", "phone" as "number", CASE WHEN "street1" is NULL THEN  '' ELSE street1 END as street,CASE WHEN "city" is NULL THEN '' ELSE city END, CASE WHEN "state" is NULL THEN '' ELSE state END,CASE WHEN "pincode" is NULL THEN '' ELSE pincode END,CASE WHEN "country" is NULL THEN '' ELSE country END, "account_key" as "accountKey" ,"hospital_photo" as photo from account_details WHERE hospital_name ~* $1`,
    getDocListForPatient:
      'SELECT * from  appointment a join doctor d on a."doctorId"= d."doctorId" join doc_config dc on dc."doctor_key"=d."doctor_key" join account_details ad on ad."account_key" = d."account_key" where a."patient_id" = $1',
    getPastAppointments:
      `SELECT * FROM appointment WHERE (("appointment_date" <= $2 AND "status"= $3) OR("appointment_date" <= $5 AND "startTime" <= $6 AND ("status"=$4 OR "status"= $7))) AND "patient_id" = $1 AND "is_cancel"=false `,
    getUpcomingAppointments:
      'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2  AND "status"= $3 OR "status"=$4 AND "is_cancel"=false',
      getUpcomingAppointmentsCounts:
      `SELECT * FROM appointment a WHERE ((a."appointment_date" = $5 and a."startTime" >= $6) or (a."appointment_date" >= $2)) AND (a."patient_id" = $1 or (a.attender_mobile = (select phone from patient_details where patient_id = $1))) AND (a."status"= $3 OR a."status"= $4) AND a."is_cancel"=false order by appointment_date asc , a."startTime" asc `,
    getDeleteReport: "update patient_report set active=false where id= $1",
    getReportId: "update appointment set reportid= $1 where id=$2",
    getExistAppointment:
      'SELECT * FROM appointment WHERE "doctorId"=$1 AND "patient_id"=$2 AND "appointment_date"=$3 AND "is_cancel"=false',
    getUpcomingAppointmentsForPatient:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime", a."endTime", a."doctorId", a."patient_id" as "patientId", adc."is_preconsultation_allowed",adc."pre_consultation_hours",adc."pre_consultation_mins", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName" FROM appointment a join appointment_doc_config adc ON a."id" = adc."appointment_id" join doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."patient_id" = $1 AND a."doctorId" = $4 AND a."appointment_date" >= $2 AND a."is_cancel"=false AND (a.status= $5 OR a.status=$6) order by appointment_date limit 10 offset $3',
    getUpcomingAppointmentsForPatientAdmin:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime", a."endTime", a."doctorId", a."patient_id" as "patientId", adc."is_preconsultation_allowed",adc."pre_consultation_hours",adc."pre_consultation_mins", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName" FROM appointment a join appointment_doc_config adc ON a."id" = adc."appointment_id" join doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."patient_id" = $1 AND a."doctorId" = ANY(SELECT doc."doctorId" From doctor doc where account_key=$4) AND a."appointment_date" >= $2 AND a."is_cancel"=false AND (a.status= $5 OR a.status=$6) order by appointment_date limit 10 offset $3',
    getAppDoctorList:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime", a."endTime", a."doctorId", a."patient_id" as "patientId", adc."is_preconsultation_allowed",adc."pre_consultation_hours",adc."pre_consultation_mins", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName"  FROM appointment a join appointment_doc_config adc ON a."id" = adc."appointment_id" join doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key"  WHERE a."doctorId" = $1 AND a."patient_id" = $2 AND a.appointment_date >= $3 AND a."is_cancel"=false AND (a.status= $4 OR a.status = $5) order by appointment_date',
    getAppDoctorListForAdmin :
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime", a."endTime", a."doctorId", a."patient_id" as "patientId", adc."is_preconsultation_allowed",adc."pre_consultation_hours",adc."pre_consultation_mins", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName"  FROM appointment a join appointment_doc_config adc ON a."id" = adc."appointment_id" join doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key"  WHERE a."doctorId" = ANY(SELECT doc."doctorId" From doctor doc where account_key=$1) AND a."patient_id" = $2 AND a.appointment_date >= $3 AND a."is_cancel"=false AND (a.status= $4 OR a.status = $5) order by appointment_date',
    getPastAppointmentsForPatient:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime",a."endTime",a."patient_id" as "patientId", a."doctorId", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName" FROM appointment a join  doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."patient_id" = $1 AND a."doctorId" = $4 AND a."appointment_date" <= $2 AND a."is_cancel"=false AND a.status= $5 order by a.appointment_date limit 10 offset $3',
    getPastAppointmentsForPatientAdmin:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime",a."endTime",a."patient_id" as "patientId", a."doctorId", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName" FROM appointment a join  doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."patient_id" = $1 AND a."doctorId" = ANY(SELECT doc."doctorId" From doctor doc where account_key=$4) AND a."appointment_date" <= $2 AND a."is_cancel"=false AND a.status= $5 order by a.appointment_date limit 10 offset $3',
    getPastAppDoctorList:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate", a."startTime",a."endTime",a."patient_id" as "patientId", a."doctorId",d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName"  FROM appointment a join  doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."doctorId" = $1 AND a."patient_id" = $2 AND a.appointment_date <= $3 AND a.status= $4 order by a.appointment_date',
    getPastAppDoctorListForAdmin:
      'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate", a."startTime",a."endTime",a."patient_id" as "patientId", a."doctorId",d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName"  FROM appointment a join  doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."doctorId" = ANY(SELECT doc."doctorId" From doctor doc where account_key=$1) AND a."patient_id" = $2 AND a.appointment_date <= $3 AND a.status= $4 order by a.appointment_date',
    getPatientDoctorApps:
      `SELECT pd.* ,a.patient_id from appointment a join patient_details pd ON a."patient_id" = pd."patient_id"
      WHERE a."doctorId" = $1 AND  a."is_cancel"=false AND
      (pd.name ~* $2 OR pd.email ~* $2 OR pd.phone ~* $2) group by pd.id,a.patient_id`,
    getPatientAdminApps:
      `SELECT pd.* ,a.patient_id from appointment a join patient_details pd ON a."patient_id" = pd."patient_id"
      WHERE a."doctorId" = ANY(SELECT doc."doctorId" From doctor doc where account_key=$1) AND  a."is_cancel"=false AND
      (pd.name ~* $2 OR pd.email ~* $2 OR pd.phone ~* $2) group by pd.id,a.patient_id`,

    getAccountAppList:
      'SELECT * from appointment WHERE "doctorId" = $1 order by appointment_date',
    sunday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    monday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    tuesday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    wednesday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    thursday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    friday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    saturday:
      'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    docConfig:
      "INSERT INTO public.doc_config(doctor_key, consultation_cost) VALUES ($1, $2);",
    getDoctorKey:
      "SELECT replace(users.doctor_key, 'Doc_', '') AS maxDoc FROM users WHERE doctor_key notnull order by replace(users.doctor_key, 'Doc_', '')::int desc limit 1",
    getRegKey:
      "SELECT replace(doctor.registration_number, 'RegD_', '') AS maxReg FROM doctor WHERE doctor.registration_number notnull order by replace(doctor.registration_number, 'RegD_', '')::int desc limit 1",
    getUser: "SELECT users.id FROM users order by id desc limit 1",
    insertDoctor:
      "INSERT INTO public.users(id, name, email, password, salt, account_id, doctor_key)VALUES ($1, $2, $3, $4, $5, $6, $7);",
      getTodayAppointments:
      `SELECT *, 0 as "isAttenderApp" FROM appointment a WHERE ((a."appointment_date" = $5 and a."startTime" >= $6) or (a."appointment_date" >= $2)) AND (a."patient_id" = $1 or (a.attender_mobile = (select phone from patient_details where patient_id = $1))) AND (a."status"= $3 OR a."status"= $4) AND a."is_cancel"=false UNION SELECT *, 1 as "isAttenderApp" FROM appointment a WHERE ((a."appointment_date" = $5 and a."startTime" >= $6) or (a."appointment_date" >= $2)) AND (a."patient_id" = $1 or (a.attender_mobile = (select phone from patient_details where patient_id = $1))) AND (a."status"= $3 OR a."status"= $4) AND a."is_cancel"=false GROUP BY id order by appointment_date asc , "startTime" asc `,
    getAccountKey:
      "SELECT replace(account.account_key, 'Acc_', '') AS maxAcc FROM account WHERE account_key notnull order by replace(account.account_key, 'Acc_', '')::int desc limit 1",
    getPrescription: 'SELECT * FROM prescription WHERE "appointment_id" = $1',
    getTableData: "SELECT * FROM ",
    updateSignature: `UPDATE doctor SET "signature" = $2 WHERE "doctorId" = $1`,
    getPatientDetailLabReport: `SELECT  DISTINCT ON (appointment_id)report."appointment_id" as appointmentId , report."comments" as comment, report."file_type" as fileType, report."file_name" as fileName, report."report_url" as attachment, report."report_date" as reportDate from patient_report report  left join  appointment  on appointment."id" = report."appointment_id"  where report."patient_id" = $1 and (report."appointment_id" ! = NULL OR report."appointment_id"  IS not NULL)`,
    getDoctorPatientDetailLabReport: `SELECT report."comments" as comment, 
      report."file_type" as fileType, report."file_name" as fileName, report."report_url" as attachment, 
      report."report_date" as reportDate 
      from patient_report report  
      where report."patient_id" = $1`,
      getPatientReportDetails:`SELECT * FROM patient_report where patient_id=$1 AND active=true AND file_name=$2 and file_type=$3`,
    
    removeAttenderDetailsByPatient:`update appointment set attender_mobile=null , attender_name=null , attender_email=null where id=$1`,
      // Doctor report common fields
    getDoctorReportField: `Select DISTINCT  appointment."appointment_date", appointment."startTime",
                             regexp_replace(regexp_replace(regexp_replace(CAST(appointment."status" as varchar),'notCompleted','Not Completed'),'completed','Completed'),'paused','Paused')as status,appointment."patient_id" ,appointment."createdTime", 
                              patient."honorific" , patient."name" as "patientName" , patient."phone" ,
                              (coalesce(payment."amount", '0'))as amount  , appointment."slotTiming" ,
                              doctor."doctor_name" as "doctorName" `,
    getDoctorReportFromField: ` from doctor `,
    getDoctorReportWhereForDoctor: ` where doctor."doctor_key" = $1 `,
    getDoctorReportWhereForAdmin: ` where doctor."account_key" = $1 `,
    getDocDetailsFromApp: 'select a."doctorId", a.patient_id, a.attender_mobile, d.doctor_key, d.live_status, d.video_call_details from appointment a join doctor d on a."doctorId" = d."doctorId" where id = $1',
    getDocAndPatDetailsByAppId: 'select p.name as "patientName", p."firstName" as "patientFirstName", p."lastName" as "patientLastName", p.email as "patientEmail", p.phone as "patientPhone", a.*, d.doctor_name, d.email as "doctorEmail", d.number as "doctorPhone", d.speciality , d.doctor_key as "doctorKey" , d.first_name as "doctorFirstName", d.last_name as "doctorLastName" from appointment a join patient_details p on a.patient_id = p.patient_id join doctor d on a."doctorId" = d."doctorId" where a.id = $1 and a."is_cancel" = false',
    // getDoctorReportListisActive: ' and appointment."is_active"',
    // Appointment list report
    getAppointmentListReportJoinField: ` left join appointment on appointment."doctorId" = doctor."doctorId" 
                                          left join patient_details patient on patient."patient_id"= appointment."patient_id" 
                                          left join payment_details payment on payment."appointment_id" = appointment."id" `,
  
    getAppointmentListReport: ` AND appointment."is_active" and appointment."appointment_date" =$2 order by appointment."appointment_date"  DESC `,
    getAppointmentListReportWithLimit: ` AND appointment."is_active"  and appointment."appointment_date" =$4  order by appointment."appointment_date"  DESC offset $2 limit $3`,
    getAppointmentListReportWithSearch: `  AND appointment."is_active" AND (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4)) and appointment."appointment_date" =$5 order by appointment."appointment_date"  DESC offset $2 limit $3`,
    getAppointmentListReportWithoutLimitSearch: ` AND appointment."is_active"  AND (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2))  and appointment."appointment_date" = $3 order by appointment."appointment_date"  DESC`,
    getAppointmentListReportWithFilterSearch:
      'AND appointment."is_active"  and appointment."appointment_date" BETWEEN $5 and $6  AND (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4))  order by appointment."appointment_date"  DESC offset $2 limit $3',
    getAppointmentListReportWithoutLimitFilterSearch:
      ' AND appointment."is_active" and appointment."appointment_date" BETWEEN $3 and $4  AND (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2)) order by appointment."appointment_date"  DESC',
    getAppointmentListReportWithFilter:
      ' AND appointment."is_active" and appointment."appointment_date" BETWEEN $4 and $5  order by appointment."appointment_date"  DESC offset $2 limit $3',
    getAppointmentListReportWithoutLimitFilter:
      ' AND appointment."is_active" and appointment."appointment_date" BETWEEN $2 and $3  order by appointment."appointment_date"  DESC',
    getDocDetailsByAppId: 'SELECT d."doctorId", d."doctor_key" as "doctorKey", d.doctor_name as "doctorName", d.email FROM doctor d JOIN appointment a ON a."doctorId" = d."doctorId" where id =$1',
  
    getReportVideoUsage:
      'select app."doctorId", report.* FROM public.patient_report report left outer join public.appointment app on app.id = report.appointment_id left join public.doctor doc on doc."doctorId" = app."doctorId" where report.patient_id = $2 and (report.appointment_id = $3 or doc."doctorId" = $1 or report.appointment_id is null) Order by id DESC offset $4 limit $5',
    // Amount list report
    getAmountListReportJoinField: ` left join appointment on appointment."doctorId" = doctor."doctorId"
                                      left join patient_details patient on patient."patient_id"= appointment."patient_id" 
                                      left join payment_details payment on payment."appointment_id" = appointment."id" `,
    getAmountListReport: ` and appointment."appointment_date" =$2  order by appointment."appointment_date" DESC `,
    getAmountListReportWithLimit: `  and appointment."appointment_date" =$4 order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithSearch: `  where doctor."doctor_key" =  $1   AND  (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4))  and appointment."appointment_date" =$5 order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithoutLimitSearch: `    AND  (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2))  and appointment."appointment_date" = $3 order by appointment."appointment_date" DESC`,
    getAmountListReportWithFilterSearch: `  AND appointment."created_by"='PATIENT' AND appointment."is_active" and appointment."appointment_date" BETWEEN $5 and $6 AND  (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4))  order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithoutLimitFilterSearch: ` AND appointment."created_by"='PATIENT' AND appointment."is_active"  and appointment."appointment_date" BETWEEN $3 and $4 AND (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2)) order by appointment."appointment_date" DESC`,
    getAmountListReportWithFilter: `  AND appointment."created_by"='PATIENT' AND appointment."is_active" and appointment."appointment_date" BETWEEN $4 and $5  order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithoutLimitFilter: ` AND appointment."created_by"='PATIENT' AND appointment."is_active" and appointment."appointment_date" BETWEEN $2 and $3 order by appointment."appointment_date" DESC`,
  
    getMessageTemplate:
      "SELECT template.* FROM message_metadata meta JOIN message_template template ON template.id = meta.message_template_id JOIN message_type type ON type.id = meta.message_type_id JOIN communication_type com ON com.id = meta.communication_type_id WHERE type.name = $1 AND com.name = $2",
    getAdvertisementList: `SELECT * FROM advertisement`,
  
    // get prescription
    getPrescriptionDetails: `select med.name_of_medicine as medicine , med.dose_of_medicine as comment , med.count_of_days as dose, pres.prescription_url as attachment
                              from medicine med 
                              left join prescription pres on med.prescription_id = pres.id 
                          where pres.appointment_id = $1`,
  
    getDoctorID: `select * from users where doctor_key =$1`,
    getAppointmentDetails:`select a.id as appointmentId, a.patient_id as patientId, a."doctorId"  as doctorId, a.status as status ,
                          pd.patient_id as "attenderId",a.attender_mobile as "attenderMobile" from appointment a left join patient_details pd on a.attender_mobile = pd.phone where a.id= $1 `,
    getDoctorDetailsWithAccountKey:`SELECT us.*,acc."account_key" FROM users us join account acc on us."account_id" = acc."account_id" where doctor_key =$1`,
    // get report uploaded by patient for the appointment
    getAppointmentReports: `select pr.patient_id as PatientId, pr.file_name as fileName, pr.report_url as attachment, pr.file_type as fileType, pr."comments", pr.report_date as reportDate 
                                  from patient_report pr 
                               where appointment_id  = $1`,
    getRemarks: `select * from prescription where appointment_id=$1`,
    getAccountDetail: "select account_id from account where account_key=$1",
    insertDoctorInCalender:
      "INSERT INTO public.doctor(doctor_name, account_key, doctor_key, experience, speciality, qualification, number, last_name, first_name, registration_number, email, live_status)VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);",
    insertAccountDetail:
      "INSERT INTO public.account_details(account_key, hospital_name, pincode, phone, account_details_id) VALUES ($1, $2, $3, $4, $5);",
    getAccountDetailCalendar:
      "select account_details_id from account_details Order by account_details_id DESC limit 1",
  };
  