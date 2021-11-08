import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const selfAppointmentRead = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('SELF_APPOINTMENT_READ') >= 0 ? true : false;
    }
);