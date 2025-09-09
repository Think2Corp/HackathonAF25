public with sharing class ChallengeHelper {
  public static List<AmyDataKit__Challenge__c> queryChallenges(
    String status,
    Date startDate,
    Date endDate,
    String id,
    String name,
    String manager
  ) {
    String query = 'SELECT Id, Name, AmyDataKit__Status__c, AmyDataKit__Type__c, AmyDataKit__Description__c, AmyDataKit__Result__c, AmyDataKit__SlackChannel__c, AmyDataKit__StartDate__c, AmyDataKit__EndDate__c, AmyDataKit__Manager__c, AmyDataKit__Manager__r.Name, AmyDataKit__Participants__c, AmyDataKit__Reward__c FROM AmyDataKit__Challenge__c';
    List<String> conditions = new List<String>();

    // Build query conditions based on input
    if (status != null) {
      conditions.add('AmyDataKit__Status__c = :status');
    }
    if (startDate != null) {
      conditions.add('AmyDataKit__StartDate__c >= :startDate');
    }
    if (endDate != null) {
      conditions.add('AmyDataKit__EndDate__c <= :endDate');
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
      conditions.add('AmyDataKit__Manager__r.Name LIKE :likeManager');
    }

    // If no conditions, return empty results
    if (!conditions.isEmpty()) {
      query += ' WHERE ';
      query += String.join(conditions, ' AND ');
    }
    // Execute query and return results
    return Database.query(query);
  }

  public static List<AmyDataKit__Challenge__c> filterChallengesByParticipant(
    List<AmyDataKit__Challenge__c> challenges,
    String participantRole,
    String participantName
  ) {
    if (String.isBlank(participantRole) && String.isBlank(participantName)) {
      return challenges; // Return all challenges if no participant filter is provided
    }

    String participantRoleFilter = participantRole != null ? participantRole.toLowerCase().trim() : null;
    String participantNameFilter = participantName != null ? participantName.toLowerCase().trim() : null;
    List<AmyDataKit__Challenge__c> filteredChallenges = new List<AmyDataKit__Challenge__c>();

    for (AmyDataKit__Challenge__c challenge : challenges) {
      if (
        challenge.AmyDataKit__Participants__c != null &&
        ((participantRoleFilter != null &&
        challenge.AmyDataKit__Participants__c.toLowerCase().contains(participantRoleFilter)) ||
        (participantNameFilter != null &&
        challenge.AmyDataKit__Participants__c.toLowerCase().contains(participantNameFilter)))
      ) {
        filteredChallenges.add(challenge);
      }
    }

    return filteredChallenges;
  }
}
