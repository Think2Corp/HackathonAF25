# GetUsersFromTextList Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class GetUsersFromTextList {
  public class Input {
    @InvocableVariable(
      required=true
      description='Input string containing user names or roles in the format "[Name1, Name2, Name3]"'
    )
    public String inputText;
  }

  public class Output {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='List of User IDs found')
    public List<Id> userIds;
    @InvocableVariable(description='List of User sObjects found')
    public List<User> users;

    public Output(String message, List<Id> userIds, List<User> users) {
      this.message = message;
      this.userIds = userIds;
      this.users = users;
    }
  }

  @InvocableMethod(
    label='Get Users from Text List'
    description='Extract user names or roles from input text, query users, and return their IDs and sObjects'
  )
  public static List<Output> getUsersFromTextList(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', new List<Id>(), new List<User>()));
      return results;
    }

    Input input = inputList[0];
    List<String> identifiers = UserHelper.extractIdentifiersFromText(input.inputText);
    if (identifiers.isEmpty()) {
      results.add(new Output('No identifiers found in input text', new List<Id>(), new List<User>()));
      return results;
    }

    List<User> users = UserHelper.queryUsersByIdentifiers(identifiers);
    if (users.isEmpty()) {
      results.add(new Output('No users found for the given identifiers', new List<Id>(), new List<User>()));
    } else {
      List<Id> userIds = new List<Id>();
      for (User user : users) {
        userIds.add(user.Id);
      }
      results.add(new Output('Users retrieved successfully', userIds, users));
    }

    return results;
  }
}

```

## Methods

### `getUsersFromTextList(inputList)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> getUsersFromTextList(List<Input> inputList)
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

##### `inputText`

`INVOCABLEVARIABLE`

###### Signature

```apex
public inputText
```

###### Type

String

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

##### `userIds`

`INVOCABLEVARIABLE`

###### Signature

```apex
public userIds
```

###### Type

List&lt;Id&gt;

---

##### `users`

`INVOCABLEVARIABLE`

###### Signature

```apex
public users
```

###### Type

List&lt;User&gt;

#### Constructors

##### `Output(message, userIds, users)`

###### Signature

```apex
public Output(String message, List<Id> userIds, List<User> users)
```

###### Parameters

| Name    | Type             | Description |
| ------- | ---------------- | ----------- |
| message | String           |             |
| userIds | List&lt;Id&gt;   |             |
| users   | List&lt;User&gt; |             |
