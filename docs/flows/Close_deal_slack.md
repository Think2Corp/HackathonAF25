# Close deal slack + AI

## Flow Diagram

![diagram](./Close_deal_slack-1.svg)

<!-- Flow description -->

## General Information

| <!-- -->                                     | <!-- -->                                  |
| :------------------------------------------- | :---------------------------------------- |
| Object                                       | Opportunity                               |
| Process Type                                 | Auto Launched Flow                        |
| Trigger Type                                 | Record After Save                         |
| Record Trigger Type                          | Update                                    |
| Label                                        | Close deal slack + AI                     |
| Status                                       | Obsolete                                  |
| Does Require Record Changed To Meet Criteria | ✅                                        |
| Environments                                 | Default                                   |
| Interview Label                              | Close deal slack {!$Flow.CurrentDateTime} |
| Source Template                              | sales_channel\_\_DealWon                  |
| Builder Type (PM)                            | LightningFlowBuilder                      |
| Canvas Mode (PM)                             | AUTO_LAYOUT_CANVAS                        |

#### Scheduled Paths

| Label    | Name     | Offset Number | Offset Unit | Record Field | Time Source | Connector                                                                 |
| :------- | :------- | :------------ | :---------- | :----------- | :---------- | :------------------------------------------------------------------------ |
| <!-- --> | <!-- --> | <!-- -->      | <!-- -->    | <!-- -->     | <!-- -->    | [GetNotificationRecipients_DealsWon](#getnotificationrecipients_dealswon) |

#### Filters (logic: **and**)

| Filter Id | Field     | Operator |   Value    |
| :-------- | :-------- | :------: | :--------: |
| 1         | StageName | Equal To | Closed Won |

## Variables

| Name                   | Data Type | Is Collection | Is Input | Is Output | Object Type | Description |
| :--------------------- | :-------: | :-----------: | :------: | :-------: | :---------: | :---------- |
| SlackChannels_DealsWon |  String   |      ✅       |    ✅    |    ⬜     |  <!-- -->   | <!-- -->    |

## Constants

| Name                         | Data Type |   Value   | Description                                     |
| :--------------------------- | :-------: | :-------: | :---------------------------------------------- |
| NotificationPurpose_DealsWon |  String   | Deals Won | Stores the type of Slack notifications to send. |

## Flow Nodes Details

### Call_Amy

| <!-- -->                   | <!-- -->                                                    |
| :------------------------- | :---------------------------------------------------------- |
| Type                       | Action Call                                                 |
| Label                      | Call Amy                                                    |
| Action Type                | Generate Ai Agent Response                                  |
| Action Name                | Amy                                                         |
| Flow Transaction Model     | CurrentTransaction                                          |
| Name Segment               | Amy                                                         |
| Offset                     | 0                                                           |
| Store Output Automatically | ✅                                                          |
| User Message (input)       | {!PromptAgentforopportunitycelebration}                     |
| Connector                  | [Send_Slack_Message_Action_1](#send_slack_message_action_1) |

### Send_Slack_Message_Action_1

| <!-- -->                             | <!-- -->                    |
| :----------------------------------- | :-------------------------- |
| Type                                 | Action Call                 |
| Label                                | Send Slack Message Action 1 |
| Action Type                          | Slack Post Message          |
| Action Name                          | slackPostMessage            |
| Flow Transaction Model               | CurrentTransaction          |
| Name Segment                         | slackPostMessage            |
| Offset                               | 0                           |
| Store Output Automatically           | ✅                          |
| Slack App Id For Token (input)       | A03269G3DNE                 |
| Slack Workspace Id For Token (input) | T08LMTRBD2B                 |
| Slack Conversation Id (input)        | C08MEA2DEJK                 |
| Slack Message (input)                | Call_Amy.agentResponse      |

### SendSlackNotifications_DealsWon

| <!-- -->               | <!-- -->                                                                                                             |
| :--------------------- | :------------------------------------------------------------------------------------------------------------------- |
| Type                   | Action Call                                                                                                          |
| Label                  | Send Slack Notifications                                                                                             |
| Action Type            | Send Notification                                                                                                    |
| Action Name            | deal_won                                                                                                             |
| Description            | Calls an invocable action to send notifications to all specified feed channels with the "Deals Won" broadcast topic. |
| Flow Transaction Model | CurrentTransaction                                                                                                   |
| Name Segment           | deal_won                                                                                                             |
| Offset                 | 0                                                                                                                    |
| Record Id (input)      | $Record.Id                                                                                                           |
| Recipient Ids (input)  | SlackChannels_DealsWon                                                                                               |
| Connector              | [Call_Amy](#call_amy)                                                                                                |

### GetNotificationRecipients_DealsWon

| <!-- -->           | <!-- -->                                                                                      |
| :----------------- | :-------------------------------------------------------------------------------------------- |
| Type               | Subflow                                                                                       |
| Label              | Get Notification Recipients                                                                   |
| Description        | Gets the Slack channels associated with the broadcast topic specified in NotificationPurpose. |
| Flow Name          | sales_channel\_\_NotificationsSubflow                                                         |
| Output Assignments | assignToReference: SlackChannels_DealsWon<br/>name: SlackChannelIds<br/>                      |
| Connector          | [SendSlackNotifications_DealsWon](#sendslacknotifications_dealswon)                           |

#### Input Assignments

| Field    |            Value             |
| :------- | :--------------------------: |
| <!-- --> | NotificationPurpose_DealsWon |

---

_Documentation generated from branch documentation by [sfdx-hardis](https://sfdx-hardis.cloudity.com), featuring [salesforce-flow-visualiser](https://github.com/toddhalfpenny/salesforce-flow-visualiser)_
