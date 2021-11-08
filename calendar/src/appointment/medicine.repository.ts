import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Medicine } from "./medicine.entity";



@EntityRepository(Medicine)
export class MedicineRepository extends Repository<Medicine> {

    private logger = new Logger('MedicineRepository');
    async medicineInsertion(medicineDto: any): Promise<any> {

        const medicine = new Medicine();
        medicine.id = medicineDto.id,
        medicine.prescriptionId = medicineDto.prescriptionId;
        medicine.nameOfMedicine = medicineDto.nameOfMedicine;
        medicine.countOfDays = medicineDto.countOfDays ? medicineDto.countOfDays : null;
        medicine.doseOfMedicine = medicineDto.doseOfMedicine;
        medicine.typeOfMedicine = medicineDto.typeOfMedicine ? medicineDto.typeOfMedicine : null;
        medicine.frequencyOfEachDose = medicineDto.frequencyOfEachDose;
        medicine.countOfMedicineForEachDose = 0;

        try {
            const acc = await medicine.save();
            return acc;
        } catch (error) {
            this.logger.error(`Unexpected medicine save error` + error.message);
            throw new InternalServerErrorException();
        }
    }

}