public with sharing class UserHelper {
  public UserHelper() {
  }

  @InvocableMethod(
    label='Get User Details'
    description='Query user details or role by name'
  )
  public static List<GenericResultWrapper> getUserDetails(
    List<QueryWrapper> queryWrapperList
  ) {
    List<GenericResultWrapper> results = new List<GenericResultWrapper>();
    if (queryWrapperList == null || queryWrapperList.isEmpty()) {
      results.add(
        new GenericResultWrapper('No input provided', null, null, null)
      );
      return results;
    }
    QueryWrapper queryWrapper = queryWrapperList[0];
    String likeName = '%' + queryWrapper.name + '%';

    if (queryWrapper.queryType == 'user') {
      // Query user details
      List<User> users = [
        SELECT Id, Name, Email
        FROM User
        WHERE Name LIKE :likeName
      ];
      if (users.isEmpty()) {
        results.add(
          new GenericResultWrapper('No users found', null, null, null)
        );
        return results;
      }
      for (User user : users) {
        results.add(
          new GenericResultWrapper(
            'User found: ' + user.Name,
            user.Id,
            user.Email,
            null
          )
        );
      }
    } else if (queryWrapper.queryType == 'role') {
      // Query user role details
      List<User> users = [
        SELECT Id, Name, UserRole.Id, UserRole.Name
        FROM User
        WHERE Name LIKE :likeName
      ];
      if (users.isEmpty()) {
        results.add(
          new GenericResultWrapper('No users found', null, null, null)
        );
        return results;
      }
      for (User user : users) {
        if (user.UserRole != null) {
          results.add(
            new GenericResultWrapper(
              'User found: ' + user.Name,
              user.UserRole.Id,
              null,
              user.UserRole.Name
            )
          );
        } else {
          results.add(
            new GenericResultWrapper(
              'User found: ' + user.Name + ' (No role assigned)',
              null,
              null,
              null
            )
          );
        }
      }
    } else {
      results.add(
        new GenericResultWrapper('Invalid query type', null, null, null)
      );
    }
    return results;
  }

  public class QueryWrapper {
    @InvocableVariable(required=true description='Name to search for')
    public String name;
    @InvocableVariable(
      required=true
      description='Type of query: "user" or "role"'
    )
    public String queryType;
  }

  public class GenericResultWrapper {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='ID (User or Role)')
    public String id;
    @InvocableVariable(description='Email (for user queries)')
    public String email;
    @InvocableVariable(description='Role Name (for role queries)')
    public String roleName;

    public GenericResultWrapper(
      String message,
      String id,
      String email,
      String roleName
    ) {
      this.message = message;
      this.id = id;
      this.email = email;
      this.roleName = roleName;
    }
  }
}
