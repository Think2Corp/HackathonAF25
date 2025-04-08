public with sharing class SendSlackToChannel {

    // Replace this with your real bot token (starts with xoxb-)
    private static final String SLACK_BOT_TOKEN = 'xoxb-8701943387079-8708672092535-CG61Xmo1PXvfmf66i6YIuz9P';

    @InvocableMethod(label='Send Slack Message' description='Sends a simple message to a Slack channel')
    public static void postMessage(List<SlackMessageRequest> requests) {
        for (SlackMessageRequest request : requests) {
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint('https://slack.com/api/chat.postMessage');
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('Authorization', 'Bearer ' + SLACK_BOT_TOKEN);

            // Prepare the payload
            String payload = '{"channel":"' + request.channelId + '", "text":"' + request.messageText + '"}';
            httpRequest.setBody(payload);

            Http http = new Http();
            HttpResponse response = http.send(httpRequest);

            // Simple success/failure logging
            if (response.getStatusCode() == 200) {
                System.debug('Slack message sent successfully.');
            } else {
                System.debug('Failed to send Slack message.');
            }
        }
    }

    // Simple class for message details
    public class SlackMessageRequest {
        @InvocableVariable(label='Channel ID' description='Slack Channel ID (e.g. C01XXXXXXX)')
        public String channelId;

        @InvocableVariable(label='Message Text' description='The text message to send to Slack')
        public String messageText;
    }
}