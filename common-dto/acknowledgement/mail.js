"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Email = void 0;
const nodemailer = require("nodemailer");
const config_1 = require("../config");
// import {HttpStatus} from '@nestjs/common';
class Email {
    constructor() { }
    async sendEmail(params) {
        // var smtpUser = "support@virujh.com";
        // var smtpPass = "Viruj!2Yda";
        var smtpHost = "smtp.gmail.com";
        var smtpPort = 465;
        let transporter = nodemailer.createTransport({
            host: smtpHost,
            port: smtpPort,
            secure: true,
            auth: {
                // user: smtpUser,
                // pass: smtpPass
                user: params.fromEmail,
                pass: params.fromEmailPass
            },
            tls: {
                rejectUnauthorized: false
            }
        });
        let mailOptions = {
            from: `"notification@virujh.com" <${params.fromEmail}>`,
            to: params.recipient,
            // cc: params.cc,
            // bcc: params.bcc,
            subject: params.subject,
            html: params.template,
        };
        if (params.isCCAvailable) {
            mailOptions.cc = params.ccEmail;
        }
        transporter.sendMail(mailOptions, async (err, info) => {
            if (err) {
                console.log("line ==> 55", err);
                return {
                    statusCode: 501,
                    message: config_1.CONSTANT_MSG.MAIL_ERROR
                };
            }
            else {
                return {
                    statusCode: 200,
                    message: config_1.CONSTANT_MSG.MAIL_OK
                };
            }
        });
    }
}
exports.Email = Email;
