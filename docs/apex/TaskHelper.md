# TaskHelper Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class TaskHelper {
  public static List<Task> queryTasks(
    String subject,
    String owner,
    String status,
    String priority,
    Date dueDate,
    Date dueDateStart,
    Date dueDateEnd,
    String whatId,
    String whoId,
    String taskSubtype
  ) {
    String query = 'SELECT Id, Subject, OwnerId, Owner.Name, Status, Priority, ActivityDate, Description, WhatId, WhoId FROM Task';
    List<String> conditions = new List<String>();

    // Build query conditions based on input
    if (subject != null) {
      String likeSubject = '%' + subject + '%';
      conditions.add('Subject LIKE :likeSubject');
    }
    if (owner != null) {
      String likeOwner = '%' + owner + '%';
      conditions.add('Owner.Name LIKE :likeOwner');
    }
    if (status != null) {
      conditions.add('Status = :status');
    }
    if (priority != null) {
      conditions.add('Priority = :priority');
    }
    if (dueDate != null) {
      conditions.add('ActivityDate = :dueDate');
    } else {
      if (dueDateStart != null && dueDateEnd != null) {
        conditions.add('ActivityDate >= :dueDateStart AND ActivityDate <= :dueDateEnd');
      }
    }
    if (whatId != null) {
      conditions.add('WhatId = :whatId');
    }
    if (whoId != null) {
      conditions.add('WhoId = :whoId');
    }
    if (taskSubtype != null) {
      conditions.add('TaskSubtype = :taskSubtype');
    }

    // Add conditions to query if any exist
    if (!conditions.isEmpty()) {
      query += ' WHERE ' + String.join(conditions, ' AND ');
    }

    // Execute query and return results
    return Database.query(query);
  }
}

```

## Methods

### `queryTasks(subject, owner, status, priority, dueDate, dueDateStart, dueDateEnd, whatId, whoId, taskSubtype)`

#### Signature

```apex
public static List<Task> queryTasks(String subject, String owner, String status, String priority, Date dueDate, Date dueDateStart, Date dueDateEnd, String whatId, String whoId, String taskSubtype)
```

#### Parameters

| Name         | Type   | Description |
| ------------ | ------ | ----------- |
| subject      | String |             |
| owner        | String |             |
| status       | String |             |
| priority     | String |             |
| dueDate      | Date   |             |
| dueDateStart | Date   |             |
| dueDateEnd   | Date   |             |
| whatId       | String |             |
| whoId        | String |             |
| taskSubtype  | String |             |

#### Return Type

**List&lt;Task&gt;**
