---
hide:
  - path
---

# GetUsersInfoSlack Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class GetUsersInfoSlack {
  public class Input {
    @InvocableVariable(description='Optional list of Salesforce User IDs to filter')
    public List<Id> userSalesforceIds;

    @InvocableVariable(description='Optional list of Slack User IDs to filter')
    public List<Id> userSlackIds;
  }

  public class UserInfoWrapper {
    @InvocableVariable(description='User Name')
    public String name;
    @InvocableVariable(description='Salesforce User ID')
    public String salesforceId;
    @InvocableVariable(description='Slack User ID')
    public String slackId;

    public UserInfoWrapper(String name, String salesforceId, String slackId) {
      this.name = name;
      this.salesforceId = salesforceId;
      this.slackId = slackId;
    }
  }

  public class Output {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='List of User Info')
    public List<UserInfoWrapper> userInfoList;
    @InvocableVariable(description='Stringified List of User Info')
    public List<String> userInfoListString;

    public Output(String message, List<UserInfoWrapper> userInfoList, List<String> userInfoListString) {
      this.message = message;
      this.userInfoList = userInfoList;
      this.userInfoListString = userInfoListString;
    }
  }

  @InvocableMethod(
    label='Get Users Info for Slack'
    description='Retrieve a list of User Info including Name, Salesforce ID, and Slack ID, the optional userIds filter can be used to limit the results'
  )
  public static List<Output> getUsersInfoSlack(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', new List<UserInfoWrapper>(), new List<String>()));
      return results;
    }

    Input input = inputList[0];
    List<Id> userSalesforceIds = input.userSalesforceIds != null ? input.userSalesforceIds : new List<Id>();
    List<String> userSlackIds = input.userSlackIds != null ? input.userSlackIds : new List<String>();

    List<UserInfoWrapper> userInfoList = SlackHelper.getUsersInfo(userSalesforceIds, userSlackIds);
    List<String> userInfoListString = new List<String>();

    for (UserInfoWrapper userInfo : userInfoList) {
      userInfoListString.add(
        'Name=' + userInfo.name + ', Salesforce ID=' + userInfo.salesforceId + ', Slack ID=' + userInfo.slackId
      );
    }

    if (userInfoList.isEmpty()) {
      results.add(new Output('No users found', userInfoList, userInfoListString));
    } else {
      results.add(new Output('Users retrieved successfully', userInfoList, userInfoListString));
    }

    return results;
  }
}

```

## Methods

### `getUsersInfoSlack(inputList)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> getUsersInfoSlack(List<Input> inputList)
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

##### `userSalesforceIds`

`INVOCABLEVARIABLE`

###### Signature

```apex
public userSalesforceIds
```

###### Type

List&lt;Id&gt;

---

##### `userSlackIds`

`INVOCABLEVARIABLE`

###### Signature

```apex
public userSlackIds
```

###### Type

List&lt;Id&gt;

### UserInfoWrapper Class

#### Fields

##### `name`

`INVOCABLEVARIABLE`

###### Signature

```apex
public name
```

###### Type

String

---

##### `salesforceId`

`INVOCABLEVARIABLE`

###### Signature

```apex
public salesforceId
```

###### Type

String

---

##### `slackId`

`INVOCABLEVARIABLE`

###### Signature

```apex
public slackId
```

###### Type

String

#### Constructors

##### `UserInfoWrapper(name, salesforceId, slackId)`

###### Signature

```apex
public UserInfoWrapper(String name, String salesforceId, String slackId)
```

###### Parameters

| Name         | Type   | Description |
| ------------ | ------ | ----------- |
| name         | String |             |
| salesforceId | String |             |
| slackId      | String |             |

### Output Class

#### Fields

##### `message`

`INVOCABLEVARIABLE`

###### Signature

```apex
public message
```

###### Type

String

---

##### `userInfoList`

`INVOCABLEVARIABLE`

###### Signature

```apex
public userInfoList
```

###### Type

List&lt;UserInfoWrapper&gt;

---

##### `userInfoListString`

`INVOCABLEVARIABLE`

###### Signature

```apex
public userInfoListString
```

###### Type

List&lt;String&gt;

#### Constructors

##### `Output(message, userInfoList, userInfoListString)`

###### Signature

```apex
public Output(String message, List<UserInfoWrapper> userInfoList, List<String> userInfoListString)
```

###### Parameters

| Name               | Type                        | Description |
| ------------------ | --------------------------- | ----------- |
| message            | String                      |             |
| userInfoList       | List&lt;UserInfoWrapper&gt; |             |
| userInfoListString | List&lt;String&gt;          |             |
