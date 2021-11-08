export class UserDto {

    id: number;
    name: string;
    email: string;
    password: string;
    accountId: number;
    doctorKey: string;
    isActive:boolean;
    updatedTime:Date;
    role:string;
    confirmPassword:string;
    passcode:string;
    photo:string;
    hospitalPhoto:string;
    hospitalName:string;
    timeZone: string;
}