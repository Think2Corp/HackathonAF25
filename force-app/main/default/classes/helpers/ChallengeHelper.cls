public with sharing class ChallengeHelper {
  public ChallengeHelper() {
  }

  public static List<Challenge__c> queryChallenges(
    String status,
    Date startDate,
    Date endDate,
    String id,
    String name,
    String manager
  ) {
    String query = 'SELECT Id, Name, Status__c, Type__c, Description__c, Result__c, SlackChannel__c, StartDate__c, EndDate__c, Manager__c, Manager__r.Name, Participants__c FROM Challenge__c WHERE ';
    List<String> conditions = new List<String>();

    // Build query conditions based on input
    if (status != null) {
      conditions.add('Status__c = :status');
    }
    if (startDate != null) {
      conditions.add('StartDate__c >= :startDate');
    }
    if (endDate != null) {
      conditions.add('EndDate__c <= :endDate');
    }
    if (id != null) {
      conditions.add('Id = :id');
    }
    if (name != null) {
      String likeName = '%' + name + '%';
      conditions.add('Name LIKE :likeName');
    }
    if (manager != null) {
      String likeManager = '%' + manager + '%';
      conditions.add('Manager__r.Name LIKE :likeManager');
    }

    // If no conditions, return empty results
    if (!conditions.isEmpty()) {
      query += String.join(conditions, ' AND ');
    } else {
      return new List<Challenge__c>();
    }

    // Execute query and return results
    return Database.query(query);
  }

  public static List<Challenge__c> filterChallengesByParticipant(
    List<Challenge__c> challenges,
    String participantIdentifier
  ) {
    if (String.isBlank(participantIdentifier)) {
      return challenges; // Return all challenges if no participant filter is provided
    }

    String participantFilter = participantIdentifier.toLowerCase();
    List<Challenge__c> filteredChallenges = new List<Challenge__c>();

    for (Challenge__c challenge : challenges) {
      if (
        challenge.Participants__c != null &&
        challenge.Participants__c.toLowerCase().contains(participantFilter)
      ) {
        filteredChallenges.add(challenge);
      }
    }

    return filteredChallenges;
  }
}
