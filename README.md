## **Inspiration**

As Sales Managers and Salesforce experts, we’ve seen how motivation directly impacts performance—yet most tools focus on data, not people. Sales teams today are more distributed, working from both the office and remotely, and still need shared rituals: challenges, recognition, and celebration to build team spirit. With AgentMotivator, we also wants to highlight diverse sales profiles, especially those who perform well but don’t naturally showcase their success. By bringing AI into the mix, we put people back at the center of sales team engagement.

## **What it does**

Amy is a Slack-integrated Agentforce agent designed to boost sales team engagement and performance. Amy automatically identifies the most challenging deals closed by sales reps and celebrates their wins with personalized congratulatory messages, fostering a positive and motivating team culture.

Sales managers can use Amy to effortlessly create, announce, manage, and close custom sales challenges all in natural language, directly within Slack. No complex setup or dashboards required: simply chat with Amy to launch new competitions, keep everyone motivated, and recognize top performers in real time.

Amy has a customizable personality set by the manager and can adapt to each sales rep’s preferred style of interaction.

With Amy, powering up your sales team’s motivation is as simple as starting a conversation.

### **Challenge Management for Sales Managers**

Easily create, launch, and monitor personalized sales challenges directly within Salesforce, tailored to team objectives and individual rep performance.

### **Challenge and Opportunity Follow-up for Sales Reps**

Give reps visibility on their progress in challenges and help them focus on the right opportunities—especially those at risk through smart, contextual nudges.

### **Slack Challenge Animation, Celebrations, and Rep Support**

Bring the energy to where teams collaborate : Slack. Amy animates challenges, celebrates wins, and supports reps with timely, personalized messages to foster emulations.

### **Prediction on Opportunity Difficulty**

Predict which opportunities are the most difficult to close based on past data and rep feedback allowing Amy to use this information for selecting most relevant deals to celebrate, adapt its messages or calculate challenges results.

## **How we built it**

### **Agentforce Service Agent**

We used an Agent Service Agent for its standalone & Slack capabilities that we enhanced with Custom Actions.

### **Prompt Builder**

### **Einstein Studio**

### **Slack**

## **Challenges we ran into**

### **Unstructured \<-\> Structured Data switching**

Since we work with agents and natural language processing, we often handle unstructured data. However, actions or flow inputs require structured data. Switching between these two formats while keeping the benefits of AI’s flexible behavior was sometimes difficult. To address this, we used specific action input instructions for simple cases and relied on carefully designed dedicated prompts in Prompt Builder for more complex scenarios.

### **Slack Integration**

AgentForce is already integrated with Slack and provides some custom Slack actions. However, at the time this proof of concept was developed, it still could not handle more advanced features, such as posting messages in public channels. By combining AgentForce custom actions with the Slack API, these gaps can be filled. This allows a wider range of interactions and automations to be supported directly in Slack.

### **Non-Deterministic triggering**

Our goal was to maintain an undeterministic approach to celebrating closed deals, giving the Agent autonomy to choose which achievements truly stood out. Ideally, Amy would proactively identify and celebrate notable wins on her own. In practice, we found the most reliable method was to trigger the Agent for every closed-won opportunity and have it decide, based on its own evaluation criteria, whether the deal merited celebration.

## **Accomplishments that we're proud of**

##

## **What we learned**

As long as you provide agent with enough contextual data he's pretty good at determining reasoning from NLP request / description, for example he understand how to query the right records and get the right method to calculate challenge results or progress from a simple description like

`"The winner is the reps with the biggest opportunity value and the most call's type tasks"`.

## **What's next for AgentMotivator**

Better slack Integration :

- Make use of Slack Blocks to format message
- More action buttons

Better non-deterministic triggering
[Project Documentation](docs/index.md)
