# GetChallenges Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class GetChallenges {
  public class Input {
    @InvocableVariable(description='The Challenge Status of the Challenge to search for')
    public String status;
    @InvocableVariable(description='The Start Date of the Challenge to search for')
    public Date startDate;
    @InvocableVariable(description='The End Date of the Challenge to search for')
    public Date endDate;
    @InvocableVariable(description='The Challenge ID of the Challenge to search for')
    public String id;
    @InvocableVariable(description='The Name of the Challenge to search for')
    public String name;
    @InvocableVariable(description='The Manager of the Challenge to search for')
    public String manager;
    @InvocableVariable(description='The Role of the Participant of the Challenge to search for')
    public String participantRole;
    @InvocableVariable(description='The Name of the Participant of the Challenge to search for')
    public String participantName;
  }

  public class Output {
    @InvocableVariable(description='List of Challenge Objects found')
    public List<Challenge__c> challenges;
    @InvocableVariable(description='Result message of the search')
    public String message;

    public Output(List<Challenge__c> challenges, String message) {
      this.challenges = challenges;
      this.message = message;
    }
  }

  @InvocableMethod(label='Get Challenges' description='Query challenges based on various criteria')
  public static List<Output> getChallenges(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output(new List<Challenge__c>(), 'No input provided'));
      return results;
    }

    Input queryInput = inputList[0];
    List<Challenge__c> challenges = ChallengeHelper.queryChallenges(
      queryInput.status,
      queryInput.startDate,
      queryInput.endDate,
      queryInput.id,
      queryInput.name,
      queryInput.manager
    );

    // Delegate participant filtering to ChallengeHelper
    List<Challenge__c> filteredChallenges = ChallengeHelper.filterChallengesByParticipant(
      challenges,
      queryInput.participantRole,
      queryInput.participantName
    );

    if (filteredChallenges.isEmpty()) {
      results.add(new Output(new List<Challenge__c>(), 'No challenges found'));
    } else {
      results.add(new Output(filteredChallenges, 'Challenges retrieved successfully'));
    }

    return results;
  }
}

```

## Methods

### `getChallenges(inputList)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> getChallenges(List<Input> inputList)
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

##### `status`

`INVOCABLEVARIABLE`

###### Signature

```apex
public status
```

###### Type

String

---

##### `startDate`

`INVOCABLEVARIABLE`

###### Signature

```apex
public startDate
```

###### Type

Date

---

##### `endDate`

`INVOCABLEVARIABLE`

###### Signature

```apex
public endDate
```

###### Type

Date

---

##### `id`

`INVOCABLEVARIABLE`

###### Signature

```apex
public id
```

###### Type

String

---

##### `name`

`INVOCABLEVARIABLE`

###### Signature

```apex
public name
```

###### Type

String

---

##### `manager`

`INVOCABLEVARIABLE`

###### Signature

```apex
public manager
```

###### Type

String

---

##### `participantRole`

`INVOCABLEVARIABLE`

###### Signature

```apex
public participantRole
```

###### Type

String

---

##### `participantName`

`INVOCABLEVARIABLE`

###### Signature

```apex
public participantName
```

###### Type

String

### Output Class

#### Fields

##### `challenges`

`INVOCABLEVARIABLE`

###### Signature

```apex
public challenges
```

###### Type

List&lt;Challenge\_\_c&gt;

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

##### `Output(challenges, message)`

###### Signature

```apex
public Output(List<Challenge__c> challenges, String message)
```

###### Parameters

| Name       | Type                       | Description |
| ---------- | -------------------------- | ----------- |
| challenges | List&lt;Challenge\_\_c&gt; |             |
| message    | String                     |             |
