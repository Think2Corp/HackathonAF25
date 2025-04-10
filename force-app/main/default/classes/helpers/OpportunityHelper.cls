public with sharing class OpportunityHelper {
  public OpportunityHelper() {
  }

  public static List<Opportunity> queryOpportunities(
    String name,
    String owner,
    Date closeDate,
    String type,
    String stage
  ) {
    String query = 'SELECT Id, Name, Owner.Name, Amount, Type, CloseDate, StageName, Difficulty__c, Description FROM Opportunity';
    List<String> conditions = new List<String>();

    // Build query conditions based on input
    if (name != null) {
      String likeName = '%' + name + '%';
      conditions.add('Name LIKE :likeName');
    }
    if (owner != null) {
      String likeOwner = '%' + owner + '%';
      conditions.add('Owner.Name LIKE :likeOwner');
    }
    if (closeDate != null) {
      conditions.add('CloseDate = :closeDate');
    }
    if (type != null) {
      conditions.add('Type = :type');
    }
    if (stage != null) {
      conditions.add('StageName = :stage');
    }

    // If no conditions, return empty results
    if (!conditions.isEmpty()) {
      query += ' WHERE ' + String.join(conditions, ' AND ');
    }

    // Execute query and return results
    return Database.query(query);
  }
}
