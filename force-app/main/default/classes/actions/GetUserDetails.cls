public with sharing class GetUserDetails {
  public GetUserDetails() {
  }

  @InvocableMethod(
    label='Get User Details'
    description='Query user details by name'
  )
  public static List<ActionHelper.GenericResultWrapper> getUserDetails(
    List<ActionHelper.QueryWrapper> queryWrapperList
  ) {
    List<ActionHelper.GenericResultWrapper> results = new List<ActionHelper.GenericResultWrapper>();
    if (queryWrapperList == null || queryWrapperList.isEmpty()) {
      results.add(
        new ActionHelper.GenericResultWrapper('No input provided', null)
      );
      return results;
    }

    ActionHelper.QueryWrapper queryWrapper = queryWrapperList[0];
    List<User> users = UserHelper.queryUsersByName(queryWrapper.name);

    if (users.isEmpty()) {
      results.add(
        new ActionHelper.GenericResultWrapper('No users found', null)
      );
    } else {
      for (User user : users) {
        results.add(new ActionHelper.GenericResultWrapper('User found', user));
      }
    }

    return results;
  }
}
