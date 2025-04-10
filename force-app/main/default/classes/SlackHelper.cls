public with sharing class SlackHelper {  

    public class ReturnToken {
        public String token;
        public String message;
    }

    public class ReturnSlackCallout {
        public String message;
        public HttpResponse res;
    }

    public static ReturnToken getBotToken(String agentName, String userSlackBotToken) {
        
        ReturnToken result = new ReturnToken();


        SlackBotToken__mdt tokenMetadata = [
            SELECT Bot_User_OAuth_Token__c 
            FROM SlackBotToken__mdt
            WHERE DeveloperName = :agentName 
            LIMIT 1
        ];

        if (tokenMetadata != null) {
            result.token = tokenMetadata.Bot_User_OAuth_Token__c;
            result.message = 'No token provided, using token from custom metadata';

        } else {
            result.token = null;
        }

            if (!String.isBlank(userSlackBotToken)) {
                result.token = userSlackBotToken;
                result.message = 'Token fetched from input';

            }

            if (String.isBlank(result.token)) {
            result.message = 'No token provided';
            }

            return result;       
    }

    public static ReturnSlackCallout SlackApiCallout(String endpoint, String method, String token, String payload) {

        ReturnSlackCallout result = new ReturnSlackCallout();

        // Check if the token is provided
        if (String.isBlank(token)) {
            result.status = 'error';
            result.message = 'No token provided';
            return result;
        }

        // Check if the endpoint is provided
        if (String.isBlank(endpoint)) {
            result.status = 'error';
            result.message = 'No endpoint provided';
            return result;
        }

     try {
        // Setup the HTTP request   
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setBody(payload);

        Http http = new Http();
        result.res = http.send(req);

        return result;
        } 
        if (result.res.getStatusCode() == 200) {
            System.debug('Slack API callout successful: ' + res.getBody());
            SlackApiCallout.message = 'Slack API callout successful';
            return result;
        } else {
            System.debug('Slack API callout failed: ' + res.getBody());
            SlackApiCallout.message = 'Slack API callout failed: ' + res.getBody();
            return result;
        }
        } catch (HttpResponseException e) {
            System.debug('HTTP response error: ' + e.getMessage());
            SlackApiCallout.message = 'HTTP response error: ' + e.getMessage();
            return result;
        }
    }
    






    
}