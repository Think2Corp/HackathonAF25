public with sharing class GetUsersOfRole {
  public GetUsersOfRole() {
  }

  @InvocableMethod(
    label='Get Users of Role'
    description='Query users by role name or role ID'
  )
  public static List<ActionHelper.UserResultWrapper> getUsersOfRole(
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
    List<User> users = UserHelper.queryUsersByRole(queryWrapper.name);

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
