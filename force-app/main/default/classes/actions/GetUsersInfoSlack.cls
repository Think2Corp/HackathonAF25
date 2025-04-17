public with sharing class GetUsersInfoSlack {
  public class Input {
    @InvocableVariable(description='Optional list of User IDs to filter')
    public List<Id> userIds;
  }

  public class UserInfoWrapper {
    @InvocableVariable(description='User Name')
    public String name;
    @InvocableVariable(description='Salesforce User ID')
    public String salesforceId;
    @InvocableVariable(description='Slack User ID')
    public String slackId;

    public UserInfoWrapper(String name, String salesforceId, String slackId) {
      this.name = name;
      this.salesforceId = salesforceId;
      this.slackId = slackId;
    }
  }

  public class Output {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='List of User Info')
    public List<UserInfoWrapper> userInfoList;
    @InvocableVariable(description='Stringified List of User Info')
    public List<String> userInfoListString;

    public Output(String message, List<UserInfoWrapper> userInfoList, List<String> userInfoListString) {
      this.message = message;
      this.userInfoList = userInfoList;
      this.userInfoListString = userInfoListString;
    }
  }

  @InvocableMethod(
    label='Get Users Info for Slack'
    description='Retrieve a list of User Info including Name, Salesforce ID, and Slack ID, the optional userIds filter can be used to limit the results'
  )
  public static List<Output> getUsersInfoSlack(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', new List<UserInfoWrapper>(), new List<String>()));
      return results;
    }

    Input input = inputList[0];
    List<UserInfoWrapper> userInfoList = SlackHelper.getUsersInfo(input.userIds);
    List<String> userInfoListString = new List<String>();

    for (UserInfoWrapper userInfo : userInfoList) {
      userInfoListString.add(
        'Name=' + userInfo.name + ', Salesforce ID=' + userInfo.salesforceId + ', Slack ID=' + userInfo.slackId
      );
    }

    if (userInfoList.isEmpty()) {
      results.add(new Output('No users found', userInfoList, userInfoListString));
    } else {
      results.add(new Output('Users retrieved successfully', userInfoList, userInfoListString));
    }

    return results;
  }
}
