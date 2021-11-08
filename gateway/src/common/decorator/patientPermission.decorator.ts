import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const patient = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permission;
        return permissions.indexOf('CUSTOMER') >= 0 ? true : false;
    }
);