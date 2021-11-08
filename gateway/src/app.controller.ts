import { Controller, Get, UseGuards, Req } from '@nestjs/common';
import { AppService } from './app.service';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from './common/decorator/get-user.decorator';
import { GetAppointment } from './common/decorator/get-appointment.decorator';
import { GetDoctor } from './common/decorator/get-doctor.decorator';
import { UserDto,AppointmentDto, DoctorDto, DoctorConfigPreConsultationDto ,DocConfigDto,WorkScheduleDto,PatientDto,HospitalDto,PrescriptionDto} from 'common-dto';

@Controller('api')
export class AppController {
  constructor(private readonly appService: AppService) {}

  
}
