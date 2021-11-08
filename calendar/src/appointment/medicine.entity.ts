import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class Medicine extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'prescription_id'
    })
    prescriptionId : number;

    @Column({
        name : 'name_of_medicine'
    })
    nameOfMedicine : string;

    @Column({
        name : 'frequency_of_each_dose'
    })
    frequencyOfEachDose : string;

    @Column({
        name : 'count_of_medicine_for_each_dose'
    })
    countOfMedicineForEachDose : number;
    
    @Column({
        name : 'type_of_medicine'
    })
    typeOfMedicine : string;

    @Column({
        name : 'count_of_days'
    })
    countOfDays : string;

    @Column({
        name : 'dose_of_medicine'
    })
    doseOfMedicine : string;
}