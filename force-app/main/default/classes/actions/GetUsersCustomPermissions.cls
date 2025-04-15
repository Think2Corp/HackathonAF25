public with sharing class GetUsersCustomPermissions {
  public class Input {
    @InvocableVariable(description='Optional list of user names')
    public List<String> userNames;
    @InvocableVariable(description='Optional list of user IDs')
    public List<Id> userIds;
  }

  public class UserPermissionsWrapper {
    @InvocableVariable(description='User Name')
    public String userName;
    @InvocableVariable(description='Salesforce User ID')
    public Id userId;
    @InvocableVariable(description='List of Custom Permissions')
    public List<String> customPermissions;

    public UserPermissionsWrapper(String userName, Id userId, List<String> customPermissions) {
      this.userName = userName;
      this.userId = userId;
      this.customPermissions = customPermissions;
    }
  }

  public class Output {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='List of User Permissions Info')
    public List<UserPermissionsWrapper> userPermissionsList;

    public Output(String message, List<UserPermissionsWrapper> userPermissionsList) {
      this.message = message;
      this.userPermissionsList = userPermissionsList;
    }
  }

  @InvocableMethod(
    label='Get Users Custom Permissions'
    description='Retrieve a list of users and their custom permissions based on optional filters: userNames or userIds'
  )
  public static List<Output> getUsersCustomPermissions(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', new List<UserPermissionsWrapper>()));
      return results;
    }

    Input input = inputList[0];
    Map<Id, List<String>> userPermissionsMap = UserHelper.getCustomPermissionsForUsers(input.userIds, input.userNames);

    // Pre-fetch user data for all user IDs in the map
    Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN :userPermissionsMap.keySet()]);

    List<UserPermissionsWrapper> userPermissionsList = new List<UserPermissionsWrapper>();
    for (Id userId : userPermissionsMap.keySet()) {
      User user = userMap.get(userId);
      if (user != null) {
        userPermissionsList.add(new UserPermissionsWrapper(user.Name, user.Id, userPermissionsMap.get(userId)));
      }
    }

    if (userPermissionsList.isEmpty()) {
      results.add(new Output('No users or permissions found', userPermissionsList));
    } else {
      results.add(new Output('Users and permissions retrieved successfully', userPermissionsList));
    }

    return results;
  }
}
