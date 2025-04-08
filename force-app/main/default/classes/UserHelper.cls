public with sharing class UserHelper {
  public UserHelper() {
  }

  public static List<User> queryUsersByName(String name) {
    String likeName = '%' + name + '%';
    return [
      SELECT
        Id,
        FirstName,
        LastName,
        Name,
        Email,
        UserRoleId,
        UserRole.Name,
        Manager.Name,
        ManagerId,
        Department
      FROM User
      WHERE Name LIKE :likeName
    ];
  }
}
