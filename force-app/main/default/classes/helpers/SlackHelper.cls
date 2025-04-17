public with sharing class SlackHelper {
  public class ReturnToken {
    public String token;
    public String message;
  }

  public class ReturnSlackCallout {
    public string status;
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

    // Use the token from metadata if available
    if (tokenMetadata != null) {
      result.token = tokenMetadata.Bot_User_OAuth_Token__c;
      result.message = 'No token provided, using token from custom metadata';
    } else {
      result.token = null;
    }

    // Override with the user-provided token if available
    if (!String.isBlank(userSlackBotToken)) {
      result.token = userSlackBotToken;
      result.message = 'Token fetched from input';
    }

    // Handle cases where no token is available
    if (String.isBlank(result.token)) {
      result.message = 'No token provided';
    }

    return result;
  }

  public static ReturnSlackCallout SlackApiCallout(String endpoint, String method, String token, String payload) {
    ReturnSlackCallout result = new ReturnSlackCallout();

    // Check if the token is provided
    if (String.isBlank(token)) {
      result.message = 'No token provided';
      return result;
    }

    // Check if the endpoint is provided
    if (String.isBlank(endpoint)) {
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
      if (!String.isBlank(payload)) {
        req.setBody(payload);
      }

      Http http = new Http();
      result.res = http.send(req);

      if (result.res.getStatusCode() == 200) {
        System.debug('Slack API callout successful: ' + result.res.getBody());
        result.message = 'Slack API callout successful';
        result.status = 'success';
      } else {
        System.debug('Slack API callout failed: ' + result.res.getBody());
        result.message = 'Slack API callout failed: ' + result.res.getBody();
        result.status = 'error';
      }
    } catch (Exception e) {
      System.debug('HTTP response error: ' + e.getMessage());
      result.message = 'HTTP response error: ' + e.getMessage();
      result.status = 'error';
    }

    return result;
  }

  public static List<GetUsersInfoSlack.UserInfoWrapper> getUsersInfo(List<Id> userIds, List<Id> slackIds) {
    List<GetUsersInfoSlack.UserInfoWrapper> userInfoList = new List<GetUsersInfoSlack.UserInfoWrapper>();
    Map<String, String> idMapSalesforceSlack = new Map<String, String>();
    Map<String, String> idMapSlackSalesforce = new Map<String, String>();

    // Query users based on provided IDs or all users if no IDs are provided
    List<User> users;
    if (userIds != null && !userIds.isEmpty()) {
      users = [
        SELECT Id, Name
        FROM User
        WHERE Id IN :userIds
      ];
    } else {
      users = [
        SELECT Id, Name
        FROM User
      ];
    }

    // Get Slack IDs for the queried users
    List<String> salesforceIds = new List<String>();
    for (User user : users) {
      salesforceIds.add(user.Id);
    }

    String teamId = 'T08LMTRBD2B'; // More generic ??
    if (salesforceIds != null && !salesforceIds.isEmpty()) {
      idMapSalesforceSlack = Slack.UserMappingService.getSlackUserIdMap(salesforceIds, teamId);
    }
    if (slackIds != null && !slackIds.isEmpty()) {
      idMapSlackSalesforce = Slack.UserMappingService.getSalesforceUserIdMap(slackIds);
    }

    // Build the merged map <SalesforceId, SlackId>
    Map<String, String> mergedMap = new Map<String, String>();

    // Add entries from idMapSalesforceSlack directly
    if (idMapSalesforceSlack != null) {
      mergedMap.putAll(idMapSalesforceSlack);
    }

    // Add entries from idMapSlackSalesforce, ensuring <SalesforceId, SlackId> format
    for (String slackId : idMapSlackSalesforce.keySet()) {
      String salesforceId = idMapSlackSalesforce.get(slackId);
      if (!mergedMap.containsKey(salesforceId)) {
        mergedMap.put(salesforceId, slackId);
      }
    }

    // Build the user info list
    for (User user : users) {
      String slackId = mergedMap.get(user.Id);
      userInfoList.add(new GetUsersInfoSlack.UserInfoWrapper(user.Name, user.Id, slackId));
    }

    return userInfoList;
  }
}
