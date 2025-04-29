# getTasks Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class getTasks {
  public class Input {
    @InvocableVariable(description='Task Subject')
    public String subject;

    @InvocableVariable(description='Task Owner')
    public String owner;

    @InvocableVariable(description='Task Status')
    public String status;

    @InvocableVariable(description='Task Priority')
    public String priority;

    @InvocableVariable(description='Task Due Date')
    public Date dueDate;

    @InvocableVariable(description='Start Date for Due Date Range')
    public Date dueDateStart;

    @InvocableVariable(description='End Date for Due Date Range')
    public Date dueDateEnd;

    @InvocableVariable(description='Related To ID (WhatId)')
    public String whatId;

    @InvocableVariable(description='Name ID (WhoId)')
    public String whoId;

    @InvocableVariable(description='Task Subtype')
    public String taskSubtype;
  }

  public class Output {
    @InvocableVariable(description='List of Task Objects')
    public List<Task> tasks;

    @InvocableVariable(description='Result message')
    public String message;

    public Output(List<Task> tasks, String message) {
      this.tasks = tasks;
      this.message = message;
    }
  }

  @InvocableMethod(label='Get Tasks' description='Query tasks based on various criteria')
  public static List<Output> getTasks(List<Input> inputList) {
    List<Output> results = new List<Output>();

    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output(new List<Task>(), 'No input provided'));
      return results;
    }

    Input queryInput = inputList[0];
    List<Task> tasks = TaskHelper.queryTasks(
      queryInput.subject,
      queryInput.owner,
      queryInput.status,
      queryInput.priority,
      queryInput.dueDate,
      queryInput.dueDateStart,
      queryInput.dueDateEnd,
      queryInput.whatId,
      queryInput.whoId,
      queryInput.taskSubtype
    );

    if (tasks.isEmpty()) {
      results.add(new Output(tasks, 'No tasks found'));
    } else {
      results.add(new Output(tasks, 'Tasks retrieved successfully'));
    }

    return results;
  }
}

```

## Methods

### `getTasks(inputList)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> getTasks(List<Input> inputList)
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

##### `subject`

`INVOCABLEVARIABLE`

###### Signature

```apex
public subject
```

###### Type

String

---

##### `owner`

`INVOCABLEVARIABLE`

###### Signature

```apex
public owner
```

###### Type

String

---

##### `status`

`INVOCABLEVARIABLE`

###### Signature

```apex
public status
```

###### Type

String

---

##### `priority`

`INVOCABLEVARIABLE`

###### Signature

```apex
public priority
```

###### Type

String

---

##### `dueDate`

`INVOCABLEVARIABLE`

###### Signature

```apex
public dueDate
```

###### Type

Date

---

##### `dueDateStart`

`INVOCABLEVARIABLE`

###### Signature

```apex
public dueDateStart
```

###### Type

Date

---

##### `dueDateEnd`

`INVOCABLEVARIABLE`

###### Signature

```apex
public dueDateEnd
```

###### Type

Date

---

##### `whatId`

`OTHER`

###### Signature

```apex
public whatId
```

###### Type

String

---

##### `whoId`

`OTHER`

###### Signature

```apex
public whoId
```

###### Type

String

---

##### `taskSubtype`

`INVOCABLEVARIABLE`

###### Signature

```apex
public taskSubtype
```

###### Type

String

### Output Class

#### Fields

##### `tasks`

`INVOCABLEVARIABLE`

###### Signature

```apex
public tasks
```

###### Type

List&lt;Task&gt;

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

##### `Output(tasks, message)`

###### Signature

```apex
public Output(List<Task> tasks, String message)
```

###### Parameters

| Name    | Type             | Description |
| ------- | ---------------- | ----------- |
| tasks   | List&lt;Task&gt; |             |
| message | String           |             |
