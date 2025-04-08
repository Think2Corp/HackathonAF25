public with sharing class GetUserDetails {
  public GetUserDetails() {
  }

  @InvocableMethod(
    label='Get User Details'
    description='Query user details by name'
  )
  public static List<ActionHelper.UserResultWrapper> getUserDetails(
    List<ActionHelper.QueryWrapper> queryWrapperList
  ) {
    List<ActionHelper.UserResultWrapper> results = new List<ActionHelper.UserResultWrapper>();
    if (queryWrapperList == null || queryWrapperList.isEmpty()) {
      results.add(
        new ActionHelper.UserResultWrapper('No input provided', null, null)
      );
      return results;
    }

    ActionHelper.QueryWrapper queryWrapper = queryWrapperList[0];
    List<User> users = UserHelper.queryUsersByName(queryWrapper.name);

    if (users.isEmpty()) {
      results.add(
        new ActionHelper.UserResultWrapper('No users found', null, null)
      );
    } else {
      results.add(
        new ActionHelper.UserResultWrapper('Users found', null, users)
      );
    }

    return results;
  }
}
