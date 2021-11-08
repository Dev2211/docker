import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const accountUsersAppointmentWrite = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('ACCOUNT_USERS_APPOINTMENT_WRITE') >= 0 ? true : false;
    }
);