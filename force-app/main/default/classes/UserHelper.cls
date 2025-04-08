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
      results.add(new GenericResultWrapper('No input provided', null));
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
        results.add(new GenericResultWrapper('No users found', null));
        return results;
      }
      for (User user : users) {
        results.add(new GenericResultWrapper('User found', user));
      }
    } else if (queryWrapper.queryType == 'role') {
      // Query user role details
      List<User> users = [
        SELECT Id, Name, UserRole.Id, UserRole.Name
        FROM User
        WHERE Name LIKE :likeName
      ];
      if (users.isEmpty()) {
        results.add(new GenericResultWrapper('No users found', null));
        return results;
      }
      for (User user : users) {
        if (user.UserRole != null) {
          results.add(new GenericResultWrapper('User found', user.UserRole));
        } else {
          results.add(
            new GenericResultWrapper('User found (No role assigned)', null)
          );
        }
      }
    } else {
      results.add(new GenericResultWrapper('Invalid query type', null));
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
    @InvocableVariable(description='Result object as JSON string')
    public String resultObject;

    public GenericResultWrapper(String message, Object resultObject) {
      this.message = message;
      this.resultObject = resultObject != null
        ? JSON.serialize(resultObject)
        : null;
    }
  }
}
