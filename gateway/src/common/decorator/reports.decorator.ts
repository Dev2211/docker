import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const reports = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('REPORTS') >= 0 ? true : false;
    }
);