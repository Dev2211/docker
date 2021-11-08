import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { Account } from "./account.entity";
import { UserDto } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
//import { Account } from "src/account/account.entity";
import { UserRole } from "./user_role.entity";

@EntityRepository(UserRole)
export class UserRoleRepository extends Repository<UserRole> {

    private logger = new Logger('UserRoleRepository');



}