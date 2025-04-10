public with sharing class UserHelper {
  public static List<User> queryUsersByName(String name) {
    String likeName = '%' + name + '%';
    return [
      SELECT Id, FirstName, LastName, Name, Email, UserRoleId, UserRole.Name, Manager.Name, ManagerId, Department
      FROM User
      WHERE Name LIKE :likeName
    ];
  }

  public static List<User> queryUsersByRole(String roleIdentifier) {
    if (String.isBlank(roleIdentifier)) {
      return new List<User>();
    }
    String likeRoleIdentifier = '%' + roleIdentifier + '%';

    return [
      SELECT Id, FirstName, LastName, Name, Email, UserRoleId, UserRole.Name, Manager.Name, ManagerId, Department
      FROM User
      WHERE UserRole.Name LIKE :likeRoleIdentifier OR UserRoleId = :roleIdentifier
    ];
  }
}
