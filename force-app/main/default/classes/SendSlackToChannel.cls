public with sharing class SendSlackToChannel {

    // Replace this with your real bot token (starts with xoxb-)
    private static final String DEFAULT_SLACK_BOT_TOKEN = 'xoxb-8701943387079-8708672092535-CG61Xmo1PXvfmf66i6YIuz9P';

    @InvocableMethod(label='Send Slack Message to Channel' description='Sends a simple message to a Slack channel')
    public static void postMessage(List<SlackMessageRequest> requests) {
        List<String> results = new List<String>();
        for (SlackMessageRequest request : requests) {
            // Check if the optional token is provided, if not use the default
            String slackBotToken = String.isBlank(request.slackBotToken) ? DEFAULT_SLACK_BOT_TOKEN : request.slackBotToken;

            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint('https://slack.com/api/chat.postMessage');
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('Authorization', 'Bearer ' + slackBotToken);

            // Prepare the payload
            String payload = '{"channel":"' + request.channelId + '", "text":"' + request.messageText + '"}';
            httpRequest.setBody(payload);

            Http http = new Http();
            HttpResponse response = http.send(httpRequest);

            // Simple success/failure logging
            if (response.getStatusCode() == 200) {
                System.debug('Slack message sent successfully.');
                // Return the message sent on success
                results.add(request.messageText);
            } else {
                System.debug('Failed to send Slack message.');
                // Return null or an error message on failure
                results.add('Failed to send Slack message.');
            }
        }
        // Return the list of sent messages
    }

    // Simple class for message details
    public class SlackMessageRequest {
        @InvocableVariable(label='Channel ID' description='Slack Channel ID (e.g. C01XXXXXXX)')
        public String channelId;

        @InvocableVariable(label='Message Text' description='Text of the message to send to the Slack channel')
        public String messageText;

        @InvocableVariable(label='Slack Bot Token' description='Optional custom Slack bot token (starts with xoxb-)')
        public String slackBotToken;
    }
}
