# SlackCreateChannel Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class SlackCreateChannel {
  private static final String SLACK_API_URL = 'https://slack.com/api/conversations.create';

  @InvocableMethod(label='Create Slack Channel' description='Creates a new Slack channel')
  public static List<Output> createChannel(List<Input> requests) {
    List<Output> outputs = new List<Output>();

    for (Input request : requests) {
      Output output = new Output();
      String payload = '{"name":"' + request.channelName + '", "is_private":' + request.isPrivate + '}';

      SlackHelper.ReturnToken returned_token = SlackHelper.getBotToken(request.agentName, request.userSlackBotToken);
      SlackHelper.ReturnSlackCallout slackCallout = SlackHelper.SlackApiCallout(
        SLACK_API_URL,
        'POST',
        returned_token.token,
        payload
      );

      output.message = slackCallout.message;
      outputs.add(output);
    }

    return outputs;
  }

  public class Input {
    @InvocableVariable(label='Channel Name' description='Name of the Slack channel to create (lowercase, no spaces)')
    public String channelName;

    @InvocableVariable(label='Is Private' description='Whether the channel should be private')
    public Boolean isPrivate;

    @InvocableVariable(
      label='Agent Name'
      description='The name of the agent (used to fetch the bot token in the custom metadata type)'
    )
    public String agentName;

    @InvocableVariable(label='User Set Slack Bot Token' description='Optional bot token (xoxb-...)')
    public String userSlackBotToken;
  }

  public class Output {
    @InvocableVariable(label='Output Message')
    public String message;
  }
}

```

## Fields

### `SLACK_API_URL`

#### Signature

```apex
private static final SLACK_API_URL
```

#### Type

String

## Methods

### `createChannel(requests)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> createChannel(List<Input> requests)
```

#### Parameters

| Name     | Type              | Description |
| -------- | ----------------- | ----------- |
| requests | List&lt;Input&gt; |             |

#### Return Type

**List&lt;Output&gt;**

## Classes

### Input Class

#### Fields

##### `channelName`

`OTHER`

###### Signature

```apex
public channelName
```

###### Type

String

---

##### `isPrivate`

`INVOCABLEVARIABLE`

###### Signature

```apex
public isPrivate
```

###### Type

Boolean

---

##### `agentName`

`OTHER`

###### Signature

```apex
public agentName
```

###### Type

String

---

##### `userSlackBotToken`

`OTHER`

###### Signature

```apex
public userSlackBotToken
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
