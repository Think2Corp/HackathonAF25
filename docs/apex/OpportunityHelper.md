---
hide:
  - path
---

# OpportunityHelper Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class OpportunityHelper {
  public static List<Opportunity> queryOpportunities(
    String name,
    String owner,
    String ownerId,
    Date closeDate,
    Date closeDateStart,
    Date closeDateEnd,
    String type,
    String stage,
    Boolean isClosed,
    Boolean isWon
  ) {
    String query = 'SELECT Id, Name, Owner.Name, OwnerId, Amount, Type, CloseDate, StageName, Difficulty__c, Description FROM Opportunity';
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
    if (ownerId != null) {
      conditions.add('OwnerId = :ownerId');
    }
    if (closeDate != null) {
      conditions.add('CloseDate = :closeDate');
    } else {
      if (closeDateStart != null) {
        conditions.add('CloseDate >= :closeDateStart');
      }
      if (closeDateEnd != null) {
        conditions.add('CloseDate <= :closeDateEnd');
      }
    }
    if (type != null) {
      conditions.add('Type = :type');
    }
    if (stage != null) {
      conditions.add('StageName = :stage');
    }

    if (isClosed != null) {
      conditions.add('IsClosed = :isClosed');
    }

    if (isWon != null) {
      conditions.add('IsWon = :isWon');
    }

    // If no conditions, return empty results
    if (!conditions.isEmpty()) {
      query += ' WHERE ' + String.join(conditions, ' AND ');
    }

    // Execute query and return results
    return Database.query(query);
  }
}

```

## Methods

### `queryOpportunities(name, owner, ownerId, closeDate, closeDateStart, closeDateEnd, type, stage, isClosed, isWon)`

#### Signature

```apex
public static List<Opportunity> queryOpportunities(String name, String owner, String ownerId, Date closeDate, Date closeDateStart, Date closeDateEnd, String type, String stage, Boolean isClosed, Boolean isWon)
```

#### Parameters

| Name           | Type    | Description |
| -------------- | ------- | ----------- |
| name           | String  |             |
| owner          | String  |             |
| ownerId        | String  |             |
| closeDate      | Date    |             |
| closeDateStart | Date    |             |
| closeDateEnd   | Date    |             |
| type           | String  |             |
| stage          | String  |             |
| isClosed       | Boolean |             |
| isWon          | Boolean |             |

#### Return Type

**List&lt;Opportunity&gt;**
