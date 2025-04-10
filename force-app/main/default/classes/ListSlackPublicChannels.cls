public with sharing class ListSlackPublicChannels {

    private static final String SLACK_API_URL = 'https://slack.com/api/conversations.list?types=public_channel';

    // Output of the invocable method : List of channels and action message
    public class Output {
        @InvocableVariable
        public List<ChannelInfo> channelInfoList;

        @InvocableVariable(label='Output Message')
        public String message;
    }

    // Input of the invocable method : name of the agent to fetch Slack bot token from custom metadata and Slack bot token. One of them is required
    public class Input {
        @InvocableVariable(label='agentName' description='The name of the agent (used to fetch the bot token in the custom metadata type)')
        public String agentName;

        @InvocableVariable(label='User set slack Bot Token' description='Optional bot token (xoxb-...)')
        public String userSlackBotToken;
    }

    public class ChannelInfo {
        public String id;
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


    // This method will be called from the Agentforce custom action to fetch the list of public channels
    @InvocableMethod(label='List public Slack channels' description='Returns the names and IDs of public Slack channels')
    public static List<Output> getSlackChannels(List<Input> configs) {
        List<Output> Outputs = new List<Output>();

        // Loop through the list of requests
        for (Input config : configs) {
            Output Output = new Output();
            Output.channelInfoList = new List<ChannelInfo>();

// Auth

SlackHelper.ReturnToken returned_token = SlackHelper.getBotToken(config.agentName,config.userSlackBotToken);

// Get the public channels

           SlackHelper.ReturnSlackCallout slackcallout = SlackHelper.SlackApiCallout(SLACK_API_URL, 'GET', returned_token.token, null);
            Output.message=slackcallout.message;
                // Handle the response
                if (slackcallout.status == 'success') {
                    SlackResponse slackRes = (SlackResponse) JSON.deserialize(slackcallout.res.getBody(), SlackResponse.class);

                    // Check if the response is valid and parse the channels
                    if (slackRes.ok && slackRes.channels != null) {
                        for (SlackChannel ch : slackRes.channels) {
                            ChannelInfo info = new ChannelInfo();
                            info.id = ch.id;
                            info.name = ch.name;
                            Output.channelInfoList.add(info);
                            Output.message = 'Fetched ' + Output.channelInfoList.size() + ' channels';
                        }
                    } else {
                        Output.message = 'Failed to fetch channels: ' + (slackRes.ok ? 'No channels found' : 'Invalid response' + slackcallout.res.getBody());
                        Outputs.add(Output);
                        return Outputs;
                    }
                } 

            // Add the Output to the list of Outputs
            Outputs.add(Output);
        }

        // Return the list of Outputs
        return Outputs;
    }




}