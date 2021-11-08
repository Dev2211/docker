import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const accountSettingsRead = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('ACCOUNT_SETTINGS_READ') >= 0 ? true : false;
    }
);