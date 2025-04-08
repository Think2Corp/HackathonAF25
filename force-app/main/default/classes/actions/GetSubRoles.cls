public with sharing class GetSubRoles {
  public GetSubRoles() {
  }

  public class RoleResultWrapper {
    @InvocableVariable(description='Role Name')
    public String roleName;
    @InvocableVariable(description='Role ID')
    public String roleId;
    @InvocableVariable(description='Parent Role Name')
    public String parentRoleName;
    @InvocableVariable(description='Parent Role ID')
    public String parentRoleId;
    @InvocableVariable(description='List of Sub Role sObjects')
    public List<UserRole> subRoles;

    public RoleResultWrapper(
      String roleName,
      String roleId,
      String parentRoleName,
      String parentRoleId,
      List<UserRole> subRoles
    ) {
      this.roleName = roleName;
      this.roleId = roleId;
      this.parentRoleName = parentRoleName;
      this.parentRoleId = parentRoleId;
      this.subRoles = subRoles;
    }
  }

  public class RoleQueryInput {
    @InvocableVariable(
      required=true
      description='Role ID or fuzzy role name to search for'
    )
    public String roleIdentifier;
  }

  @InvocableMethod(
    label='Get Sub Roles'
    description='Query sub-roles by role ID or fuzzy role name'
  )
  public static List<RoleResultWrapper> getSubRoles(
    List<RoleQueryInput> queryInputList
  ) {
    List<RoleResultWrapper> results = new List<RoleResultWrapper>();
    if (queryInputList == null || queryInputList.isEmpty()) {
      return results;
    }

    RoleQueryInput queryInput = queryInputList[0];
    List<UserRole> roles = RoleHelper.querySubRoles(queryInput.roleIdentifier);

    if (roles.isEmpty()) {
      return results;
    }

    for (UserRole role : roles) {
      List<UserRole> subRoles = [
        SELECT Id, Name, ParentRoleId, ParentRole.Name
        FROM UserRole
        WHERE ParentRoleId = :role.Id
      ];
      results.add(
        new RoleResultWrapper(
          role.Name,
          role.Id,
          role.ParentRole != null ? role.ParentRole.Name : null,
          role.ParentRoleId,
          subRoles
        )
      );
    }

    return results;
  }
}
