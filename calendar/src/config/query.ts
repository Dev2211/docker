export const queries: any = {
 getWorkSchedule:'SELECT schDay."dayOfWeek", schDay."id" as scheduleDayId,schIntr."id" as scheduleTimeId,  schIntr."startTime", schIntr."endTime" from ' +
     'doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."doctor_id" = $1',
 getDoctorScheduleInterval: 'select dcday."doctor_id", dcday."dayOfWeek", dcday."doctor_key", dcint."startTime", dcint."endTime" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on' +
     ' dcday."id" = dcint."docConfigScheduleDayId" where dcday."doctor_key" = $1 and dcday."dayOfWeek" = $2',
 insertIntoDocConfigScheduleInterval: 'insert into doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId") values ( $1, $2, $3)',
 updateIntoDocConfigScheduleInterval: 'update  doc_config_schedule_interval set "startTime" = $1, "endTime" = $2  where "id" = $3',
 deleteDocConfigScheduleInterval: 'delete from doc_config_schedule_interval where "id" = $1 and "docConfigScheduleDayId" = $2',
 getDocDetails:'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."doctor_key" = $1',
 getDocListDetails:'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."account_key" = $1',
 getConfig:'SELECT "consultationSessionTimings","overBookingType","overBookingCount","overBookingEnabled" from doc_config where "doctor_key" = $1',
 getAppointment:'SELECT * FROM appointment WHERE $1 <= "appointment_date" AND "appointment_date" <= $2 AND "doctor_id" = $3'
}
