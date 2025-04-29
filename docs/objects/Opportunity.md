---
hide:
  - path
---

## Schema

![diagram](./Opportunity-1.svg)

<!-- Object description -->

## Fields

| Name            | Label      |  Type  | Description                                                                 |
| :-------------- | :--------- | :----: | :-------------------------------------------------------------------------- |
| Difficulty\_\_c | Difficulty | Number | Calcul of the estimated difficulty of this opportunity for Prediction Model |
| ExternalID\_\_c | ExternalID |  Text  | External ID for data import                                                 |

## Related Flows

| Object      | Name                                                                                                                                         |       Type        | Description                                |
| :---------- | :------------------------------------------------------------------------------------------------------------------------------------------- | :---------------: | :----------------------------------------- |
| 💻          | [Send_Slack_Notificaiton_for_Approaching_Opportunity_Close_Date](../flows/Send_Slack_Notificaiton_for_Approaching_Opportunity_Close_Date.md) |     Scheduled     | <!-- -->                                   |
| Opportunity | [Close_deal_slack](../flows/Close_deal_slack.md)                                                                                             | Record After Save | <!-- -->                                   |
| Opportunity | [OpportunityAfterUpdateWonAIcelebration](../flows/OpportunityAfterUpdateWonAIcelebration.md)                                                 | Record After Save | <!-- -->                                   |
| Opportunity | [Slack_Opp_Notifications](../flows/Slack_Opp_Notifications.md)                                                                               | Record After Save | Slack Notifications on Opportunity changes |
| Opportunity | [Slack_new_opportunity_notifications](../flows/Slack_new_opportunity_notifications.md)                                                       | Record After Save | Slack notifications on a new opportunity   |
| Opportunity | [slack_deal_watch](../flows/slack_deal_watch.md)                                                                                             | Record After Save | <!-- -->                                   |

## Related Apex Classes

| Apex Class                                        |   Type    |
| :------------------------------------------------ | :-------: |
| [GetOpportunities](../apex/GetOpportunities.md)   | Invocable |
| [OpportunityHelper](../apex/OpportunityHelper.md) |   Class   |

## Related Permission Sets

| Permission Set                                                                                  | User License |
| :---------------------------------------------------------------------------------------------- | :----------: |
| [ExternalIDRights](../permissionsets/ExternalIDRights.md)                                       |     None     |
| [Motivation_Agent_Permissions](../permissionsets/Motivation_Agent_Permissions.md)               |     None     |
| [SalesRep](../permissionsets/SalesRep.md)                                                       |     None     |
| [Slack_Agent_Integration_Permissions](../permissionsets/Slack_Agent_Integration_Permissions.md) |     None     |

_Documentation generated with [sfdx-hardis](https://sfdx-hardis.cloudity.com)_
