export class DoctorConfigPreConsultationDto {
    doctorConfigId: number;
    doctorKey: string;
    consultationCost: string;
    isPreconsultationAllowed: boolean;
    preconsultationHours: number;
    preconsultationMinutes: number;
    isActive: boolean;
    createdOn: Date; 
    modifiedOn:Date; 
  }