import { createParamDecorator } from "@nestjs/common";
import { UserDto } from 'common-dto';

export const GetUser = createParamDecorator((data, req) : UserDto => {
    return req.args[0].user;
})