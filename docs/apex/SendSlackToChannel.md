# SendSlackToChannel Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class SendSlackToChannel {
  private static final String SLACK_API_URL = 'https://slack.com/api/chat.postMessage?unfurl_links=true';

  public class Input {
    @InvocableVariable(
      label='Channel ID'
      description='Slack Channel ID (e.g. C01XXXXXXX) or Slack User ID (e.g. U01XXXXXXX)'
    )
    public String channelId;

    @InvocableVariable(label='Message Text' description='Text of the message to send to the Slack channel or DM')
    public String messageText;

    @InvocableVariable(
      label='agentName'
      description='The name of the agent (used to fetch the bot token in the custom metadata type)'
    )
    public String agentName;

    @InvocableVariable(label='User set slack Bot Token' description='Optional bot token (xoxb-...)')
    public String userSlackBotToken;
  }

  public class Output {
    @InvocableVariable(label='Output Message' description='Result message from Slack API')
    public String message;

    public Output(String message) {
      this.message = message;
    }
  }

  @InvocableMethod(
    label='Send Slack Message to Channel or DMs'
    description='Sends a simple message to a Slack channel or DM'
  )
  public static List<Output> postMessage(List<Input> requests) {
    List<Output> outputs = new List<Output>();

    for (Input request : requests) {
      String messageEscaped = request.messageText.replaceAll('"', '');
      // Prepare the payload
      String payload = '{"channel":"' + request.channelId + '", "text":"' + messageEscaped + '"}';
      SlackHelper.ReturnToken returnedToken = SlackHelper.getBotToken(request.agentName, request.userSlackBotToken);

      if (String.isBlank(returnedToken.token)) {
        outputs.add(new Output('No valid Slack bot token provided'));
        return outputs;
      }

      SlackHelper.ReturnSlackCallout slackCallout = SlackHelper.SlackApiCallout(
        SLACK_API_URL,
        'POST',
        returnedToken.token,
        payload
      );
      outputs.add(new Output(slackCallout.message));
    }

    // Return the list of sent messages
    return outputs;
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

### `postMessage(requests)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> postMessage(List<Input> requests)
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

##### `channelId`

`OTHER`

###### Signature

```apex
public channelId
```

###### Type

String

---

##### `messageText`

`INVOCABLEVARIABLE`

###### Signature

```apex
public messageText
```

###### Type

String

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

#### Constructors

##### `Output(message)`

###### Signature

```apex
public Output(String message)
```

###### Parameters

| Name    | Type   | Description |
| ------- | ------ | ----------- |
| message | String |             |
