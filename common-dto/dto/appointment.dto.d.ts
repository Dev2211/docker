export declare class AppointmentDto {
    id: number;
    doctorId: number;
    patientId: number;
    appointmentDate: Date;
    startTime: string;
    endTime: string;
    paymentStatus: boolean;
    isActive: boolean;
    isCancel: boolean;
    createdBy: string;
    createdId: number;
    cancelledBy: string;
    cancelledId: number;
}
