---
hide:
  - path
---

# ListSlackPublicChannels Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class ListSlackPublicChannels {
  private static final String SLACK_API_URL = 'https://slack.com/api/conversations.list?exclude_archived=true&limit=1000';

  // Input of the invocable method : name of the agent to fetch Slack bot token from custom metadata and Slack bot token. One of them is required
  public class Input {
    @InvocableVariable(
      label='agentName'
      description='The name of the agent (used to fetch the bot token in the custom metadata type)'
    )
    public String agentName;

    @InvocableVariable(label='User set slack Bot Token' description='Optional bot token (xoxb-...)')
    public String userSlackBotToken;
  }

  // Output of the invocable method : List of channels and action message
  public class Output {
    @InvocableVariable
    public List<ChannelInfo> channelInfoList;

    @InvocableVariable(label='Result Message')
    public String message;

    public Output() {
      this.message = '';
      this.channelInfoList = new List<ChannelInfo>();
    }

    public Output(String message, List<ChannelInfo> channelInfoList) {
      this.message = message;
      this.channelInfoList = channelInfoList;
    }
  }

  public class ChannelInfo {
    public String id;
    public String name;
  }

  // Slack API response model
  private class SlackResponse {
    public Boolean ok;
    public List<SlackChannel> channels;
  }

  // Slack Channel model used for deserialization
  private class SlackChannel {
    public String id;
    public String name;
  }

  // This method will be called from the AgentForce custom action to fetch the list of public channels
  @InvocableMethod(label='List public Slack channels' description='Returns the names and IDs of public Slack channels')
  public static List<Output> getSlackChannels(List<Input> configs) {
    List<Output> outputs = new List<Output>();

    // Loop through the list of requests
    for (Input config : configs) {
      Output output = new Output();
      output.channelInfoList = new List<ChannelInfo>();

      // Auth
      SlackHelper.ReturnToken returnedToken = SlackHelper.getBotToken(config.agentName, config.userSlackBotToken);
      if (String.isBlank(returnedToken.token)) {
        output.message = 'No valid Slack bot token provided';
        outputs.add(output);
        return outputs;
      }

      // Get the public channels
      SlackHelper.ReturnSlackCallout slackCallout = SlackHelper.SlackApiCallout(
        SLACK_API_URL,
        'GET',
        returnedToken.token,
        null
      );
      output.message = slackCallout.message;
      // Handle the response
      if (slackCallout.status == 'success') {
        SlackResponse slackRes = (SlackResponse) JSON.deserialize(slackCallout.res.getBody(), SlackResponse.class);

        // Check if the response is valid and parse the channels
        if (slackRes.ok && slackRes.channels != null) {
          for (SlackChannel ch : slackRes.channels) {
            ChannelInfo info = new ChannelInfo();
            info.id = ch.id;
            info.name = ch.name;
            output.channelInfoList.add(info);
            output.message = 'Fetched ' + output.channelInfoList.size() + ' channels';
          }
        } else {
          output.message =
            'Failed to fetch channels: ' +
            (slackRes.ok ? 'No channels found' : 'Invalid response' + slackCallout.res.getBody());
          outputs.add(output);
          return outputs;
        }
      }

      // Add the Output to the list of Outputs
      outputs.add(Output);
    }

    // Return the list of Outputs
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

### `getSlackChannels(configs)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> getSlackChannels(List<Input> configs)
```

#### Parameters

| Name    | Type              | Description |
| ------- | ----------------- | ----------- |
| configs | List&lt;Input&gt; |             |

#### Return Type

**List&lt;Output&gt;**

## Classes

### Input Class

#### Fields

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

##### `channelInfoList`

`INVOCABLEVARIABLE`

###### Signature

```apex
public channelInfoList
```

###### Type

List&lt;ChannelInfo&gt;

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

##### `Output()`

###### Signature

```apex
public Output()
```

---

##### `Output(message, channelInfoList)`

###### Signature

```apex
public Output(String message, List<ChannelInfo> channelInfoList)
```

###### Parameters

| Name            | Type                    | Description |
| --------------- | ----------------------- | ----------- |
| message         | String                  |             |
| channelInfoList | List&lt;ChannelInfo&gt; |             |

### ChannelInfo Class

#### Fields

##### `id`

###### Signature

```apex
public id
```

###### Type

String

---

##### `name`

###### Signature

```apex
public name
```

###### Type

String

### SlackResponse Class

#### Fields

##### `ok`

###### Signature

```apex
public ok
```

###### Type

Boolean

---

##### `channels`

###### Signature

```apex
public channels
```

###### Type

List&lt;SlackChannel&gt;

### SlackChannel Class

#### Fields

##### `id`

###### Signature

```apex
public id
```

###### Type

String

---

##### `name`

###### Signature

```apex
public name
```

###### Type

String
