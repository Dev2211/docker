"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkScheduleDto = void 0;
const class_validator_1 = require("class-validator");
class WorkScheduleDto {
}
__decorate([
    class_validator_1.IsOptional(),
    class_validator_1.IsNumber(),
    __metadata("design:type", Number)
], WorkScheduleDto.prototype, "workScheduleId", void 0);
__decorate([
    class_validator_1.IsOptional(),
    class_validator_1.IsNumber(),
    __metadata("design:type", Number)
], WorkScheduleDto.prototype, "doctorId", void 0);
__decorate([
    class_validator_1.IsOptional(),
    class_validator_1.IsMilitaryTime(),
    __metadata("design:type", String)
], WorkScheduleDto.prototype, "startTime", void 0);
__decorate([
    class_validator_1.IsOptional(),
    class_validator_1.IsIn(['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']),
    __metadata("design:type", String)
], WorkScheduleDto.prototype, "dayOfWeek", void 0);
exports.WorkScheduleDto = WorkScheduleDto;
