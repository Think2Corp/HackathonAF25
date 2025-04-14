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

    public Output(String message, List<UserInfoWrapper> userInfoList) {
      this.message = message;
      this.userInfoList = userInfoList;
    }
  }

  @InvocableMethod(
    label='Get Users Info for Slack'
    description='Retrieve a list of User Info including Name, Salesforce ID, and Slack ID, the optional userIds filter can be used to limit the results'
  )
  public static List<Output> getUsersInfoSlack(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', new List<UserInfoWrapper>()));
      return results;
    }

    Input input = inputList[0];
    List<UserInfoWrapper> userInfoList = SlackHelper.getUsersInfo(input.userIds);

    if (userInfoList.isEmpty()) {
      results.add(new Output('No users found', userInfoList));
    } else {
      results.add(new Output('Users retrieved successfully', userInfoList));
    }

    return results;
  }
}
