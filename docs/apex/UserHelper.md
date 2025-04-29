# UserHelper Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class UserHelper {
  public static List<User> queryUsersByName(String name) {
    String likeName = '%' + name + '%';
    return [
      SELECT Id, FirstName, LastName, Name, Email, UserRoleId, UserRole.Name, Manager.Name, ManagerId, Department
      FROM User
      WHERE Name LIKE :likeName
    ];
  }

  public static List<User> queryUsersByRole(String roleIdentifier) {
    if (String.isBlank(roleIdentifier)) {
      return new List<User>();
    }
    String likeRoleIdentifier = '%' + roleIdentifier + '%';

    return [
      SELECT Id, FirstName, LastName, Name, Email, UserRoleId, UserRole.Name, Manager.Name, ManagerId, Department
      FROM User
      WHERE UserRole.Name LIKE :likeRoleIdentifier OR UserRoleId = :roleIdentifier
    ];
  }

  public static List<String> extractIdentifiersFromText(String inputText) {
    if (String.isBlank(inputText)) {
      return new List<String>();
    }

    // Extract the substring between '[' and ']'
    Integer startIndex = inputText.indexOf('[');
    Integer endIndex = inputText.indexOf(']');
    if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
      return new List<String>();
    }

    String identifiersText = inputText.substring(startIndex + 1, endIndex);
    // Split by comma and trim whitespace and quote characters
    List<String> identifiers = new List<String>();
    for (String identifier : identifiersText.split(',')) {
      identifiers.add(identifier.trim().replace('"', '').replace('\'', ''));
    }

    return identifiers;
  }

  public static List<User> queryUsersByIdentifiers(List<String> identifiers) {
    if (identifiers.isEmpty()) {
      return new List<User>();
    }

    // Build dynamic WHERE clause for partial matches
    List<User> users = new List<User>();
    String baseQuery = 'SELECT Id, FirstName, LastName, Name, Email, UserRoleId, UserRole.Name, Manager.Name, ManagerId, Department FROM User WHERE ';
    List<String> conditions = new List<String>();

    for (String identifier : identifiers) {
      String likeIdentifier = '%' + String.escapeSingleQuotes(identifier) + '%';
      conditions.add('(Name LIKE \'' + likeIdentifier + '\' OR UserRole.Name LIKE \'' + likeIdentifier + '\')');
    }

    String finalQuery = baseQuery + String.join(conditions, ' OR ');

    // Execute the dynamic query
    users = Database.query(finalQuery);

    return users;
  }

  public static Set<Id> getUserIdsByNamesAndIds(List<Id> userIds, List<String> userNames) {
    // Validate inputs
    if ((userIds == null || userIds.isEmpty()) && (userNames == null || userNames.isEmpty())) {
      return new Set<Id>();
    }

    // Query users based on IDs or names using a single query with OR
    List<User> users = [
      SELECT Id, Name
      FROM User
      WHERE Id IN :userIds OR Name IN :userNames
    ];

    // Collect and return user IDs
    Set<Id> queriedUserIds = new Set<Id>();
    for (User user : users) {
      queriedUserIds.add(user.Id);
    }
    return queriedUserIds;
  }

  public static Map<Id, List<String>> getCustomPermissionsForUsers(List<Id> userIds, List<String> userNames) {
    // Use the new helper method to get user IDs
    Set<Id> queriedUserIds = getUserIdsByNamesAndIds(userIds, userNames);

    if (queriedUserIds.isEmpty()) {
      return new Map<Id, List<String>>();
    }

    // Step 2: Get all Permission Sets assigned to the users
    Map<Id, Set<Id>> userToPermissionSetIds = new Map<Id, Set<Id>>();
    for (PermissionSetAssignment psa : [
      SELECT AssigneeId, PermissionSetId
      FROM PermissionSetAssignment
      WHERE AssigneeId IN :queriedUserIds
    ]) {
      if (!userToPermissionSetIds.containsKey(psa.AssigneeId)) {
        userToPermissionSetIds.put(psa.AssigneeId, new Set<Id>());
      }
      userToPermissionSetIds.get(psa.AssigneeId).add(psa.PermissionSetId);
    }

    // Step 3: Flatten all Permission Set IDs
    Set<Id> allPermissionSetIds = new Set<Id>();
    for (Set<Id> permissionSetIds : userToPermissionSetIds.values()) {
      allPermissionSetIds.addAll(permissionSetIds);
    }

    // Step 4: Get all Custom Permissions accessible via these Permission Sets
    Map<Id, List<String>> permissionSetToCustomPermissions = new Map<Id, List<String>>();
    for (CustomPermission cp : [
      SELECT DeveloperName, Id
      FROM CustomPermission
      WHERE
        Id IN (
          SELECT SetupEntityId
          FROM SetupEntityAccess
          WHERE ParentId IN :allPermissionSetIds AND SetupEntityType = 'CustomPermission'
        )
    ]) {
      if (!permissionSetToCustomPermissions.containsKey(cp.Id)) {
        permissionSetToCustomPermissions.put(cp.Id, new List<String>());
      }
      permissionSetToCustomPermissions.get(cp.Id).add(cp.DeveloperName);
    }

    // Step 5: Map custom permissions back to users
    Map<Id, List<String>> userToCustomPermissions = new Map<Id, List<String>>();
    for (Id userId : userToPermissionSetIds.keySet()) {
      List<String> userPermissions = new List<String>();
      for (Id permissionSetId : userToPermissionSetIds.get(userId)) {
        if (permissionSetToCustomPermissions.containsKey(permissionSetId)) {
          userPermissions.addAll(permissionSetToCustomPermissions.get(permissionSetId));
        }
      }
      userToCustomPermissions.put(userId, userPermissions);
    }

    return userToCustomPermissions;
  }
}

```

## Methods

### `queryUsersByName(name)`

#### Signature

```apex
public static List<User> queryUsersByName(String name)
```

#### Parameters

| Name | Type   | Description |
| ---- | ------ | ----------- |
| name | String |             |

#### Return Type

**List&lt;User&gt;**

---

### `queryUsersByRole(roleIdentifier)`

#### Signature

```apex
public static List<User> queryUsersByRole(String roleIdentifier)
```

#### Parameters

| Name           | Type   | Description |
| -------------- | ------ | ----------- |
| roleIdentifier | String |             |

#### Return Type

**List&lt;User&gt;**

---

### `extractIdentifiersFromText(inputText)`

#### Signature

```apex
public static List<String> extractIdentifiersFromText(String inputText)
```

#### Parameters

| Name      | Type   | Description |
| --------- | ------ | ----------- |
| inputText | String |             |

#### Return Type

**List&lt;String&gt;**

---

### `queryUsersByIdentifiers(identifiers)`

#### Signature

```apex
public static List<User> queryUsersByIdentifiers(List<String> identifiers)
```

#### Parameters

| Name        | Type               | Description |
| ----------- | ------------------ | ----------- |
| identifiers | List&lt;String&gt; |             |

#### Return Type

**List&lt;User&gt;**

---

### `getUserIdsByNamesAndIds(userIds, userNames)`

#### Signature

```apex
public static Set<Id> getUserIdsByNamesAndIds(List<Id> userIds, List<String> userNames)
```

#### Parameters

| Name      | Type               | Description |
| --------- | ------------------ | ----------- |
| userIds   | List&lt;Id&gt;     |             |
| userNames | List&lt;String&gt; |             |

#### Return Type

**Set&lt;Id&gt;**

---

### `getCustomPermissionsForUsers(userIds, userNames)`

#### Signature

```apex
public static Map<Id,List<String>> getCustomPermissionsForUsers(List<Id> userIds, List<String> userNames)
```

#### Parameters

| Name      | Type               | Description |
| --------- | ------------------ | ----------- |
| userIds   | List&lt;Id&gt;     |             |
| userNames | List&lt;String&gt; |             |

#### Return Type

**Map&lt;Id,List&lt;String&gt;&gt;**
