# RoleHelper Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class RoleHelper {
  public static List<UserRole> querySubRoles(String roleIdentifier) {
    if (String.isBlank(roleIdentifier)) {
      return new List<UserRole>();
    }

    String likeRoleName = '%' + roleIdentifier + '%';

    return [
      SELECT Id, Name, ParentRoleId, ParentRole.Name
      FROM UserRole
      WHERE Name LIKE :likeRoleName OR Id = :roleIdentifier
    ];
  }
}

```

## Methods

### `querySubRoles(roleIdentifier)`

#### Signature

```apex
public static List<UserRole> querySubRoles(String roleIdentifier)
```

#### Parameters

| Name           | Type   | Description |
| -------------- | ------ | ----------- |
| roleIdentifier | String |             |

#### Return Type

**List&lt;UserRole&gt;**
