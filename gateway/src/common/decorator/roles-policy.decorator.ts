import { SetMetadata } from '@nestjs/common';

export const RolesPolicy = (...rolesPolicy: string[]) => SetMetadata('rolesPolicy', rolesPolicy);