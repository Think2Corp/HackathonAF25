# GetSubRoles Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class GetSubRoles {
  public class Input {
    @InvocableVariable(required=true description='Role ID or fuzzy role name to search for')
    public String roleIdentifier;
  }

  public class Output {
    @InvocableVariable(description='Role Name')
    public String roleName;
    @InvocableVariable(description='Role ID')
    public String roleId;
    @InvocableVariable(description='Parent Role Name')
    public String parentRoleName;
    @InvocableVariable(description='Parent Role ID')
    public String parentRoleId;
    @InvocableVariable(description='List of Sub Role sObjects')
    public List<UserRole> subRoles;
    @InvocableVariable(description='Result message')
    public String message;

    public Output(
      String roleName,
      String roleId,
      String parentRoleName,
      String parentRoleId,
      List<UserRole> subRoles,
      String message
    ) {
      this.roleName = roleName;
      this.roleId = roleId;
      this.parentRoleName = parentRoleName;
      this.parentRoleId = parentRoleId;
      this.subRoles = subRoles;
      this.message = message;
    }
  }

  @InvocableMethod(label='Get Sub Roles' description='Query sub-roles by role ID or fuzzy role name')
  public static List<Output> getSubRoles(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output(null, null, null, null, new List<UserRole>(), 'No input provided'));
      return results;
    }

    Input queryInput = inputList[0];
    List<UserRole> roles = RoleHelper.querySubRoles(queryInput.roleIdentifier);

    if (roles.isEmpty()) {
      results.add(new Output(null, null, null, null, new List<UserRole>(), 'No roles found'));
      return results;
    }

    for (UserRole role : roles) {
      List<UserRole> subRoles = [
        SELECT Id, Name, ParentRoleId, ParentRole.Name
        FROM UserRole
        WHERE ParentRoleId = :role.Id
      ];
      results.add(
        new Output(
          role.Name,
          role.Id,
          role.ParentRole != null ? role.ParentRole.Name : null,
          role.ParentRoleId,
          subRoles,
          'Role retrieved successfully'
        )
      );
    }

    return results;
  }
}

```

## Methods

### `getSubRoles(inputList)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> getSubRoles(List<Input> inputList)
```

#### Parameters

| Name      | Type              | Description |
| --------- | ----------------- | ----------- |
| inputList | List&lt;Input&gt; |             |

#### Return Type

**List&lt;Output&gt;**

## Classes

### Input Class

#### Fields

##### `roleIdentifier`

`INVOCABLEVARIABLE`

###### Signature

```apex
public roleIdentifier
```

###### Type

String

### Output Class

#### Fields

##### `roleName`

`INVOCABLEVARIABLE`

###### Signature

```apex
public roleName
```

###### Type

String

---

##### `roleId`

`INVOCABLEVARIABLE`

###### Signature

```apex
public roleId
```

###### Type

String

---

##### `parentRoleName`

`INVOCABLEVARIABLE`

###### Signature

```apex
public parentRoleName
```

###### Type

String

---

##### `parentRoleId`

`INVOCABLEVARIABLE`

###### Signature

```apex
public parentRoleId
```

###### Type

String

---

##### `subRoles`

`INVOCABLEVARIABLE`

###### Signature

```apex
public subRoles
```

###### Type

List&lt;UserRole&gt;

---

##### `message`

`INVOCABLEVARIABLE`

###### Signature

```apex
public message
```

###### Type

String

#### Constructors

##### `Output(roleName, roleId, parentRoleName, parentRoleId, subRoles, message)`

###### Signature

```apex
public Output(String roleName, String roleId, String parentRoleName, String parentRoleId, List<UserRole> subRoles, String message)
```

###### Parameters

| Name           | Type                 | Description |
| -------------- | -------------------- | ----------- |
| roleName       | String               |             |
| roleId         | String               |             |
| parentRoleName | String               |             |
| parentRoleId   | String               |             |
| subRoles       | List&lt;UserRole&gt; |             |
| message        | String               |             |
