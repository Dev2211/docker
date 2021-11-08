"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Sms = void 0;
const config_1 = require("../config");
// import * as config from '../config';
//import * as cconfig from '../../auth/config';
var request = require('request');
// import * as request from 'request';
//const textLocalConfig = cconfig.get('textLocal');
class Sms {
    constructor() {
    }
    sendSms(params) {
        console.log(params);
        try {
            // Construct data
            //let apiKey:string = "apikey=" + textLocalConfig.apiKey;
            let apiKey = "?apikey=" + params.apiKey;
            let message = "&message=" + params.message;
            let sender = "&sender=" + params.sender;
            let numbers = "&numbers=" + params.number;
            // Send data   
            var txt = 'https://api.textlocal.in/send/';
            let data = apiKey + numbers + message + sender;
            var path = txt + data;
            request.post(path, { json: { key: apiKey } }, function (error, response, body) {
                console.log("all response ===> 32", error, response, body);
                if (!error && response.statusCode == 200) {
                    console.log(body);
                    return {
                        statusCode: '200',
                        message: "SMS send successfully",
                        data: body
                    };
                }
                else {
                    return {
                        statusCode: '204',
                        message: "SMS send failed",
                    };
                }
            });
        }
        catch (e) {
            console.log(e);
            return {
                statusCode: '204',
                message: config_1.CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            };
        }
    }
    getSenderName(apiKey) {
        try {
            let data = "apikey=" + apiKey;
            let textUrl = "https://api.textlocal.in/get_sender_names/?";
            let path = textUrl + data;
            request.post(path, { json: { key: apiKey } }, function (error, response, body) {
                console.log("getSenderName res ==> 61", error, response, body);
            });
            return true;
        }
        catch (err) {
            console.log("code==> 65", err);
            return {
                statusCode: '204',
                message: config_1.CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            };
        }
    }
}
exports.Sms = Sms;
