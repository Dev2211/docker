import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const accountSettingsWrite = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('ACCOUNT_SETTINGS_WRITE') >= 0 ? true : false;
    }
);