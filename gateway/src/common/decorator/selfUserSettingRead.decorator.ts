import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const selfUserSettingRead = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('SELF_USER_SETTINGS_READ') >= 0 ? true : false;
    }
);