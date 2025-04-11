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

  public static List<String> extractIdentifiersFromText(String inputText) {
    if (String.isBlank(inputText)) {
      return new List<String>();
    }

    // Extract the substring between '[' and ']'
    Integer startIndex = inputText.indexOf('[');
    Integer endIndex = inputText.indexOf(']');
    if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
      return new List<String>();
    }

    String identifiersText = inputText.substring(startIndex + 1, endIndex);
    // Split by comma and trim whitespace and quote characters
    List<String> identifiers = new List<String>();
    for (String identifier : identifiersText.split(',')) {
      identifiers.add(identifier.trim().replace('"', '').replace('\'', ''));
    }

    return identifiers;
  }

  public static List<User> queryUsersByIdentifiers(List<String> identifiers) {
    if (identifiers.isEmpty()) {
      return new List<User>();
    }

    // Build dynamic WHERE clause for partial matches
    List<User> users = new List<User>();
    String baseQuery = 'SELECT Id, FirstName, LastName, Name, Email, UserRoleId, UserRole.Name, Manager.Name, ManagerId, Department FROM User WHERE ';
    List<String> conditions = new List<String>();

    for (String identifier : identifiers) {
      String likeIdentifier = '%' + identifier + '%';
      conditions.add('(Name LIKE :likeIdentifier OR UserRole.Name LIKE :likeIdentifier)');
    }

    String finalQuery = baseQuery + String.join(conditions, ' OR ');

    // Execute the dynamic query
    users = Database.query(finalQuery);

    return users;
  }
}
