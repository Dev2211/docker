import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
import { AccountRepository } from './account.repository';
import { RolesRepository } from './roles.repository';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import * as config from 'config';
import {RolePermissionRepository} from "./rolesPermission/role_permissions.repository";
import {PermissionRepository} from "./permissions/permission.repository";
import { UserRoleRepository } from './user_role.repository';
import { PatientRepository } from './patient.repository';

const jwtConfig = config.get('JWT'); 

@Module({
    imports: [
        TypeOrmModule.forFeature([UserRepository,AccountRepository,RolesRepository, RolePermissionRepository, PermissionRepository, UserRoleRepository, PatientRepository]),
        JwtModule.register({
            secret : jwtConfig.secret,
            signOptions : {
              expiresIn : jwtConfig.expiresIn
            }
          }),
          PassportModule.register({defaultStrategy : jwtConfig.defaultStrategy})
    ],
    controllers: [UserController],
    providers: [UserService]
})
export class UserModule { }
