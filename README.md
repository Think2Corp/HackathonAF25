# AMY, the Agent Motivator

This is the technical documentation of AMY, a Agentforce Agent Motivator, for the Virtual Agentforce Hackathon 2025.

For Hackathon Project documentation [click here](Hackathon.md)

But you can check the demo :

[![Video](https://img.youtube.com/vi/BfLAOZOtoqk/maxresdefault.jpg)](https://www.youtube.com/watch?v=BfLAOZOtoqk)

## AgentForce

- Agent
  - [Bot](./force-app/main/default/bots/Amy)
  - [GenAIPlanner](./force-app/main/default/genAiPlanners)
- Topics & Instructions
  - [Topics & Instructions](force-app/main/default/genAiPlugins)
  - [Plain Text for easier reading](./Topics)
- [Actions](./force-app/main/default/genAiFunctions)
- [Prompts](./force-app/main/default/genAiPromptTemplates)

## DataCloud

(We couldn't figure out how to retrieve the Prediction Model but we got the PredictionJobs though)

- [Datakit Installation URL](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tF9000000JHAH)
- [DataKit Metadata](./force-app/main/default/dataKit)

## Objects

- [Objects List](./docs/objects/index.md)

## Automations

- [Flows](./docs/flows/index.md)
- [Apex](./docs/apex/index.md)

## Authorizations

- [Permission Sets](./docs/permissionsets/index.md)

## UI

- [Lightning Pages](./docs/pages/index.md)

_Documentation generated from branch documentation with [sfdx-hardis](https://sfdx-hardis.cloudity.com) by [Cloudity](https://cloudity.com) command [`sf hardis:doc:project2markdown`](https://sfdx-hardis.cloudity.com/hardis/doc/project2markdown/)_
