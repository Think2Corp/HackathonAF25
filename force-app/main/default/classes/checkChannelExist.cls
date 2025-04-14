public with sharing class checkChannelExist {
    
    private static final String SLACK_API_URL = 'https://slack.com/api/conversations.list?types=public_channel';
    
    public class Input {
        @InvocableVariable(required=true label='Channel Name' description='The name of the channel to check')
        public String channelName;
        
        @InvocableVariable(label='Agent Name' description='The name of the agent (used to fetch the bot token in the custom metadata type)')
        public String agentName;
        
        @InvocableVariable(label='Slack Bot Token' description='Optional bot token (xoxb-...)')
        public String userSlackBotToken;
    }
    
    public class Output {
        @InvocableVariable(description='Whether the channel exists')
        public Boolean channelExists;

        @InvocableVariable(description='Identifier of the channel')
        public String returned_channelId;
        
        @InvocableVariable(description='Result message from the check')
        public String message;
    }
    
    private class SlackResponse {
        public Boolean ok;
        public List<SlackChannel> channels;
    }
    
    private class SlackChannel {
        public String id;
        public String name;
    }
    
    @InvocableMethod(label='Check if Slack channel exists' description='Checks if a given Slack channel name exists')
    public static List<Output> checkChannel(List<Input> inputs) {
        List<Output> outputs = new List<Output>();
        
        for (Input input : inputs) {
            Output output = new Output();
            output.channelExists = false;
            output.returned_channelId = null;
            
            // Get the bot token
            SlackHelper.ReturnToken returnedToken = SlackHelper.getBotToken(input.agentName, input.userSlackBotToken);
            
            if (String.isBlank(returnedToken.token)) {
                output.message = 'Error: ' + returnedToken.message;
                outputs.add(output);
                continue;
            }
            
            // Call Slack API
            SlackHelper.ReturnSlackCallout slackCallout = SlackHelper.SlackApiCallout(
                SLACK_API_URL,
                'GET',
                returnedToken.token,
                null
            );
            
            if (slackCallout.status == 'success') {
                SlackResponse slackRes = (SlackResponse)JSON.deserialize(
                    slackCallout.res.getBody(),
                    SlackResponse.class
                );
                
                if (slackRes.ok && slackRes.channels != null) {
                    for (SlackChannel channel : slackRes.channels) {
                        if (channel.name == input.channelName) {
                            output.channelExists = true;
                            output.returned_channelId = channel.id;
                            output.message = 'Channel found' + ' with ID: ' + channel.id;
                            break;
                        }
                    }
                    
                    if (!output.channelExists) {
                        output.message = 'Channel not found';
                    }
                } else {
                    output.message = 'Failed to fetch channels: Invalid response';
                }
            } else {
                output.message = 'API call failed: ' + slackCallout.message;
            }
            
            outputs.add(output);
        }
        
        return outputs;
    }
}
