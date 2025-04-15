public with sharing class GetMembersOfSlackChannel {
  private static final String SLACK_API_URL = 'https://slack.com/api/conversations.members';

  public class Input {
    @InvocableVariable(required=true description='Slack Channel ID (CXXXXXXXX)')
    public String channelId;

    @InvocableVariable(
      label='Agent Name'
      description='The name of the agent (used to fetch the bot token in the custom metadata type)'
    )
    public String agentName;

    @InvocableVariable(label='User set Slack Bot Token' description='Optional bot token (xoxb-...)')
    public String userSlackBotToken;
  }

  public class Output {
    @InvocableVariable(description='Result message')
    public String message;

    @InvocableVariable(description='List of Slack User IDs')
    public List<String> slackUserIds;

    public Output(String message, List<String> slackUserIds) {
      this.message = message;
      this.slackUserIds = slackUserIds;
    }
  }

  @InvocableMethod(
    label='Get Members of Slack Channel'
    description='Retrieve Slack user IDs of a Slack Channel given a Channel ID (CXXXXXXXX)'
  )
  public static List<Output> getMembersOfSlackChannel(List<Input> inputList) {
    List<Output> results = new List<Output>();

    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', new List<String>()));
      return results;
    }

    // Process only the first element of the input list
    Input input = inputList[0];

    // Validate the input
    if (String.isBlank(input.channelId)) {
      results.add(new Output('Invalid channel ID provided', new List<String>()));
      return results;
    }

    // Fetch the bot token
    SlackHelper.ReturnToken returnedToken = SlackHelper.getBotToken(input.agentName, input.userSlackBotToken);

    if (String.isBlank(returnedToken.token)) {
      results.add(new Output('No valid Slack bot token provided', new List<String>()));
      return results;
    }

    // Prepare the API endpoint with the channel ID
    String endpoint = SLACK_API_URL + '?channel=' + input.channelId;

    // Call the Slack API
    SlackHelper.ReturnSlackCallout slackCallout = SlackHelper.SlackApiCallout(
      endpoint,
      'GET',
      returnedToken.token,
      null
    );

    if (slackCallout.status == 'success') {
      // Parse the response
      Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(slackCallout.res.getBody());

      if (response.get('ok') == true) {
        // Ensure proper casting of the 'members' field
        Object membersObj = response.get('members');
        if (membersObj instanceof List<Object>) {
          List<Object> membersList = (List<Object>) membersObj;
          List<String> members = new List<String>();
          for (Object member : membersList) {
            members.add((String) member);
          }
          results.add(new Output('Successfully retrieved members', members));
        } else {
          results.add(new Output('Unexpected response format for members', new List<String>()));
        }
      } else {
        results.add(new Output('Failed to retrieve members: ' + response.get('error'), new List<String>()));
      }
    } else {
      results.add(new Output('Slack API callout failed: ' + slackCallout.message, new List<String>()));
    }

    return results;
  }
}
