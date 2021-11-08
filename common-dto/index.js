"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(exports, p)) __createBinding(exports, m, p);
};
Object.defineProperty(exports, "__esModule", { value: true });
__exportStar(require("./dto/user.dto"), exports);
__exportStar(require("./dto/appointment.dto"), exports);
__exportStar(require("./dto/doctor.dto"), exports);
__exportStar(require("./dto/account.dto"), exports);
__exportStar(require("./dto/doctor_config_preconsultation.dto"), exports);
__exportStar(require("./dto/doc_config_can_resch.dto"), exports);
__exportStar(require("./dto/doc_config.dto"), exports);
__exportStar(require("./dto/work_schedule.dto"), exports);
__exportStar(require("./dto/patient.dto"), exports);
__exportStar(require("./dto/hospital.dto"), exports);
__exportStar(require("./interface/index"), exports);
__exportStar(require("./config/index"), exports);
__exportStar(require("./dto/dbQueries/query.dto"), exports);
__exportStar(require("./acknowledgement/index"), exports);
__exportStar(require("./dto/prescription.dto"), exports);
__exportStar(require("./dto/medicine.dto"), exports);
__exportStar(require("./dto/patientReport.dto"), exports);
__exportStar(require("./dto/appointmentSessionDetails.dto"), exports);
