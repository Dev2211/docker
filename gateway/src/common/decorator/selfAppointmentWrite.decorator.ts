import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const selfAppointmentWrite = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('SELF_APPOINTMENT_WRITE') >= 0 ? true : false;
    }
);