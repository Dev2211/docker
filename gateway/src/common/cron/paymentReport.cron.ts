import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { CalendarService } from '@src/service/calendar.service';
import { UserService } from '@src/service/user.service';
import { CONSTANT_MSG } from 'common-dto';
import config from 'config';
const moment = require('moment');

@Injectable()
export class PaymentReport {
  private readonly logger = new Logger('PaymentReport');
  constructor(private readonly calendarService: CalendarService,private readonly userService: UserService  ) { 
  }

   async groupByDoctor(arr, key) {
    return  [...arr.reduce( (acc, o) =>
        acc.set(o[key], (acc.get(o[key]) || []).concat(o))
        , new Map).values()];
    } 

    async getMyDoctorsTemplate(doctorsArray){
        var docArray=[];
        var adminByDoctors="";           
        for(let i=0;i<doctorsArray.length;i++){
            var tabledata=" ";
            var tableDataPatients=" ";
            var docDetail:any;   
            var doctorNameVar=`<tr><th colspan="5">`+"Doctor Name "+" : "+(doctorsArray[i][0].DoctorName ? doctorsArray[i][0].DoctorName : '-')+`<th><tr>
                                    <tr>
                                        <th style="padding:0 5px 0 5px;">Patient Name</th>
                                        <th style="padding:0 5px 0 5px;">Date of Booking</th>
                                        <th style="padding:0 5px 0 5px;">Time Slot</th>
                                        <th style="padding:0 5px 0 5px;">Booked By</th>
                                        <th style="padding:0 5px 0 5px;">Payment Status</th>
                                    </tr>`;                      
            doctorsArray[i].forEach(element => {   
                tableDataPatients += `<tr>
                <td style="padding:0 5px 0 5px;">`+(element.patientFirstName? element.patientFirstName : '-')+ " "+(element.patientLastName ? element.patientLastName : '-')+`</td>
                <td style="padding:0 5px 0 5px;">`+(element.AppointmentCreated ? element.AppointmentCreated : '-')+`</td>
                <td style="padding:0 5px 0 5px;">`+(element.startTime ? element.startTime : '-')+"-"+(element.endTime ? element.endTime : '-')+`</td>
                <td style="padding:0 5px 0 5px;">`+(element.bookedBy ? element.bookedBy : '-')+`</td>
                <td style="padding:0 5px 0 5px;">`+(element.paymentStatus ? element.paymentStatus : '-')+`</td>
                </tr>`;             
            });
            tabledata += doctorNameVar+tableDataPatients;
            docDetail={
                docName:doctorsArray[i][0].DoctorName,
                docEmail:doctorsArray[i][0].email,
                docReportRemainder:doctorsArray[i][0].reportRemainder,
                docKey:doctorsArray[i][0].doctorKey,
                htmlData:tabledata
            };
            adminByDoctors += tabledata;
            docArray.push(docDetail);
        }          
        return{
            docArray:docArray,
            adminByDoctorsList:adminByDoctors
        }
    }

    async getEmailTemplateData(isAdmin ,arrayList ,template, adminEmailArray, today){
        if(!isAdmin){
            if(template && template.data) {
                var isDoctorAdmin:any;
                var allDoctorsListArray=arrayList;
                const getUrlPath = config.get('urlPath');
                const urlPath = getUrlPath.baseUrl + CONSTANT_MSG.DOC_APPOINTMENT_RESCHEDULE_PAGE;
                for(let i=0;i<allDoctorsListArray.length;i++){
                    isDoctorAdmin = adminEmailArray.find(val => allDoctorsListArray[i].docEmail.includes(val));
                    if(allDoctorsListArray[i].docReportRemainder===CONSTANT_MSG.REPORT_REMAINDER.ONCE_A_DAY && !isDoctorAdmin){
                            let tableData=allDoctorsListArray[i].htmlData;
                            let data = {
                                email: allDoctorsListArray[i].docEmail,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.DAILY_APPOINTMENT_REPORT,
                                sender: template.data.sender,
                                AppointmentDate:today,
                                tabledata:tableData,
                                rescheduleAppointmentUrl: urlPath+ allDoctorsListArray[i].docKey
                            };                  
                            const sendMail = await this.userService.sendEmailWithTemplate(data);
                    } 
                }    
            } else {
                console.log("Template not found for DAILY_APPOINTMENT_REPORT for DOCTOR");
            }
        }
        else{
            if(template && template.data) { 
                var adminArray=arrayList;  
                for(let i=0;i<adminArray.length;i++){                                             
                    var tableData=adminArray[i].doctorList;
                    let data = { 
                        email: adminArray[i].adminEmail,
                        template: template.data.body,
                        subject: template.data.subject,
                        type: CONSTANT_MSG.MAIL.DAILY_APPOINTMENT_REPORT,
                        sender: template.data.sender,
                        AppointmentDate:today,
                        tabledata:tableData,
                        rescheduleAppointmentUrl:''
                    };         
                    const sendMailToAdmin = await this.userService.sendEmailWithTemplate(data);
                }
            }
            else {
                console.log("Template not found for DAILY_APPOINTMENT_REPORT for ADMIN");
            }
        }
    }

  @Cron('0 0 5 * * *')
  async DailyPaymentReport(){
    const today = moment(new Date()).format('YYYY-MM-DD');
    const appointmentDetail = await this.calendarService.appointmentAlert(today);
    var allDoctorsListArray = [];
    var adminArray = [];
    var adminEmailArray=[];
    var myDoctorsListArray = []; 
    var adminDocTemplate:any; 
    
    if(appointmentDetail && appointmentDetail.length > 0){
        var accountKeyArray=[];
        for(var i=0;i<appointmentDetail.length;i++){
            accountKeyArray.push(appointmentDetail[i].data1[0].accountKey);
        }
        const adminDetail = await this.userService.adminDetails(accountKeyArray);
        
        for(var i=0;i<appointmentDetail.length;i++){
            myDoctorsListArray = [];  
            adminDocTemplate = [];  
            const adminFullArray = appointmentDetail[i].data1;            
            myDoctorsListArray = await this.groupByDoctor(adminFullArray, 'doctorKey');
            adminDocTemplate= await this.getMyDoctorsTemplate(myDoctorsListArray);
            allDoctorsListArray = [...allDoctorsListArray, ...adminDocTemplate.docArray];         
            var myAdminData= adminDetail.find(val => val.account_key === accountKeyArray[i]);
            adminEmailArray.push(myAdminData.email);
            var adminList = {
                adminEmail:  myAdminData.email,
                doctorList:  adminDocTemplate.adminByDoctorsList
            }
            adminArray.push(adminList);
        }
        const template = await this.calendarService.getMessageTemplate({messageType: 'DAILY_APPOINTMENT_REPORT', communicationType: 'Email'});
        allDoctorsListArray && allDoctorsListArray.length > 0 && await this.getEmailTemplateData(0, allDoctorsListArray, template,adminEmailArray, today);
        adminArray && adminArray.length > 0 && await this.getEmailTemplateData(1, adminArray, template, adminEmailArray, today);
 
    }  
   this.logger.log(`Cron  Api -> Request data Running and sending successfully`);
   }
}