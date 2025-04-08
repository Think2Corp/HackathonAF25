public with sharing class ListSlackPublicChannels {

    private static final String DEFAULT_SLACK_BOT_TOKEN = 'xoxb-8701943387079-8708672092535-CG61Xmo1PXvfmf66i6YIuz9P';
    private static final String SLACK_API_URL = 'https://slack.com/api/conversations.list?types=public_channel';

    // Structure de configuration (input Flow)
    public class SlackConfig {
        @InvocableVariable(label='Slack Bot Token' description='Optional bot token (xoxb-...)')
        public String slackBotToken;
    }

    // Structure de sortie (output Flow)
    public class ChannelInfo {
        @InvocableVariable(label='Channel ID')
        public String id;

        @InvocableVariable(label='Channel Name')
        public String name;
    }

    // Modèle de réponse Slack
    private class SlackResponse {
        public Boolean ok;
        public List<SlackChannel> channels;
    }

    private class SlackChannel {
        public String id;
        public String name;
    }

    // Méthode invocable (pour Flow)
    @InvocableMethod(label='List public Slack channels' description='Returns the names and IDs of public Slack channels')
    
public static List<ChannelInfo> getSlackChannels(List<SlackConfig> configs) {
 
       List<ChannelInfo> output = new List<ChannelInfo>();

        String token = DEFAULT_SLACK_BOT_TOKEN;
        if (configs != null && !configs.isEmpty() && !String.isBlank(configs[0].slackBotToken)) {
            token = configs[0].slackBotToken;
        }

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(SLACK_API_URL);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                SlackResponse slackRes = (SlackResponse) JSON.deserialize(res.getBody(), SlackResponse.class);

                if (slackRes.ok && slackRes.channels != null) {
                    for (SlackChannel ch : slackRes.channels) {
                        ChannelInfo info = new ChannelInfo();
                        info.id = ch.id;
                        info.name = ch.name;
                        output.add(info);
                    }
                } else {
                    System.debug('Slack API returned error: ' + res.getBody());
                }
            } else {
                System.debug('Slack API failed with status ' + res.getStatus() + ': ' + res.getBody());
            }

        } catch (Exception ex) {
            System.debug('Erreur lors de l’appel Slack : ' + ex.getMessage());
        }

        return output;
    }
}