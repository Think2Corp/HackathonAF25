public with sharing class ListSlackPublicChannels {

    private static final String DEFAULT_SLACK_BOT_TOKEN = 'xoxb-8701943387079-8708672092535-CG61Xmo1PXvfmf66i6YIuz9P';
    private static final String SLACK_API_URL = 'https://slack.com/api/conversations.list?types=public_channel';

    // Wrapper class to hold the result for each request
    public class Result {
        @InvocableVariable
        public List<ChannelInfo> channelInfoList;
    }

    // Structure for input (from Flow)
    public class SlackConfig {
        @InvocableVariable(label='Slack Bot Token' description='Optional bot token (xoxb-...)')
        public String slackBotToken;
    }

    // Structure for output (to Flow)
    public class ChannelInfo {
        @InvocableVariable(label='Channel ID')
        public String id;

        @InvocableVariable(label='Channel Name')
        public String name;
    }

    // Slack API response model
    private class SlackResponse {
        public Boolean ok;
        public List<SlackChannel> channels;
    }

    // Slack Channel model used for deserialization
    private class SlackChannel {
        public String id;
        public String name;
    }

    // Invocable Method for Flow
    @InvocableMethod(label='List public Slack channels' description='Returns the names and IDs of public Slack channels')
    public static List<Result> getSlackChannels(List<SlackConfig> configs) {
        List<Result> results = new List<Result>();

        // Loop through the list of requests
        for (SlackConfig config : configs) {
            Result result = new Result();
            result.channelInfoList = new List<ChannelInfo>();

            String token = DEFAULT_SLACK_BOT_TOKEN;
            if (!String.isBlank(config.slackBotToken)) {
                token = config.slackBotToken;
            }

            try {
                // Setup the HTTP request
                HttpRequest req = new HttpRequest();
                req.setEndpoint(SLACK_API_URL);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + token);
                req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

                // Send the request
                Http http = new Http();
                HttpResponse res = http.send(req);

                // Handle the response
                if (res.getStatusCode() == 200) {
                    SlackResponse slackRes = (SlackResponse) JSON.deserialize(res.getBody(), SlackResponse.class);

                    // Check if the response is valid and parse the channels
                    if (slackRes.ok && slackRes.channels != null) {
                        for (SlackChannel ch : slackRes.channels) {
                            ChannelInfo info = new ChannelInfo();
                            info.id = ch.id;
                            info.name = ch.name;
                            result.channelInfoList.add(info);
                            System.debug('Channel ID: ' + ch.id + ', Channel Name: ' + ch.name);
                        }
                    } else {
                        System.debug('Slack API returned error: ' + res.getBody());
                    }
                } else {
                    System.debug('Slack API failed with status ' + res.getStatus() + ': ' + res.getBody());
                }
            } catch (Exception ex) {
                System.debug('Error during Slack API call: ' + ex.getMessage());
            }

            // Add the result to the list of results
            results.add(result);
        }

        // Return the list of results
        System.debug('Results: ' + results);
        return results;
    }
}