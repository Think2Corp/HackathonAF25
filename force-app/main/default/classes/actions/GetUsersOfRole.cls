public with sharing class GetUsersOfRole {
  public GetUsersOfRole() {
  }

  @InvocableMethod(
    label='Get Users of Role'
    description='Query users by role name or role ID'
  )
  public static List<ActionHelper.GenericResultWrapper> getUsersOfRole(
    List<ActionHelper.QueryWrapper> queryWrapperList
  ) {
    List<ActionHelper.GenericResultWrapper> results = new List<ActionHelper.GenericResultWrapper>();
    if (queryWrapperList == null || queryWrapperList.isEmpty()) {
      results.add(
        new ActionHelper.GenericResultWrapper('No input provided', null, null)
      );
      return results;
    }

    ActionHelper.QueryWrapper queryWrapper = queryWrapperList[0];
    List<User> users = UserHelper.queryUsersByRole(queryWrapper.name);

    if (users.isEmpty()) {
      results.add(
        new ActionHelper.GenericResultWrapper('No users found', null, null)
      );
    } else {
      results.add(
        new ActionHelper.GenericResultWrapper('Users found', null, users)
      );
    }

    return results;
  }
}
