import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const accountUsersAppointmentRead = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('ACCOUNT_USERS_APPOINTMENT_READ') >= 0 ? true : false;
    }
);