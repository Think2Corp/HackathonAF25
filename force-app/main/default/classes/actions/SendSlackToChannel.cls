public with sharing class SendSlackToChannel {
  // Replace this with your real bot token (starts with xoxb-)
  private static final String SLACK_API_URL = 'https://slack.com/api/chat.postMessage';

  @InvocableMethod(label='Send Slack Message to Channel' description='Sends a simple message to a Slack channel')
  public static List<Output> postMessage(List<Input> requests) {
    List<Output> Outputs = new List<Output>();

    for (Input request : requests) {
      Output Output = new Output();
      // Prepare the payload
      String payload = '{"channel":"' + request.channelId + '", "text":"' + request.messageText + '"}';
      SlackHelper.ReturnToken returned_token = SlackHelper.getBotToken(request.agentName, request.userSlackBotToken);
      SlackHelper.ReturnSlackCallout slackcallout = SlackHelper.SlackApiCallout(
        SLACK_API_URL,
        'POST',
        returned_token.token,
        payload
      );
      Output.message = slackcallout.message;
      Outputs.add(Output);
    }
    // Return the list of sent messages

    return Outputs;
  }

  // Simple class for message details
  public class Input {
    @InvocableVariable(label='Channel ID' description='Slack Channel ID (e.g. C01XXXXXXX)')
    public String channelId;

    @InvocableVariable(label='Message Text' description='Text of the message to send to the Slack channel')
    public String messageText;

    @InvocableVariable(
      label='agentName'
      description='The name of the agent (used to fetch the bot token in the custom metadata type)'
    )
    public String agentName;

    @InvocableVariable(label='User set slack Bot Token' description='Optional bot token (xoxb-...)')
    public String userSlackBotToken;
  }

  public class Output {
    @InvocableVariable(label='Output Message' description='Result message from Slack API')
    public String message;
  }
}
