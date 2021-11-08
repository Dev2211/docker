import { TypeOrmModuleOptions} from '@nestjs/typeorm';
import * as config from 'config';
import { Users } from 'src/user/users.entity';
import { Account } from 'src/user/account.entity';
import { Roles } from 'src/user/roles.entity';
import { Permissions} from "../user/permissions/permission.entity";
import {RolePermissions} from "../user/rolesPermission/role_permissions.entity";
import { UserRole } from 'src/user/user_role.entity';
import { Patient } from 'src/user/patient.entity';

const dbConfig = config.get('database');

export const databaseConfig : TypeOrmModuleOptions = {

    type : dbConfig.type,
    host : dbConfig.host,
    port : dbConfig.port,
    username : dbConfig.username,
    password : dbConfig.password,
    database : dbConfig.database,
    entities : [Users,Account,Roles,Permissions, RolePermissions,UserRole,Patient],
    synchronize : dbConfig.synchronize

} 