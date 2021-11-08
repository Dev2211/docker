import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AppointmentModule } from './appointment/appointment.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfig } from './config/database.config';

@Module({
  imports: [AppointmentModule,
    TypeOrmModule.forRoot(databaseConfig)
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
