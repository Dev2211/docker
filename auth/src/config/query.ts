export const queries: any = {
getRolesPermission : 'SELECT "roleId", "permissionId", p."name" from role_permissions rp join permissions p on p."id" = rp."permissionId" where rp."roleId" = $1'
}
