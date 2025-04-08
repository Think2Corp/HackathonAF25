public with sharing class RoleHelper {
  public RoleHelper() {
  }

  public static List<UserRole> querySubRoles(String roleIdentifier) {
    if (String.isBlank(roleIdentifier)) {
      return new List<UserRole>();
    }

    String likeRoleName = '%' + roleIdentifier + '%';

    return [
      SELECT Id, Name, ParentRoleId, ParentRole.Name
      FROM UserRole
      WHERE Name LIKE :likeRoleName OR Id = :roleIdentifier
    ];
  }
}
