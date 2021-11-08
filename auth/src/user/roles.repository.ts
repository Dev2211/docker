import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { Account } from "./account.entity";
import { UserDto } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
//import { Account } from "src/account/account.entity";
import { Roles } from "./roles.entity";

@EntityRepository(Roles)
export class RolesRepository extends Repository<Roles> {

    private logger = new Logger('RolesRepository');



}