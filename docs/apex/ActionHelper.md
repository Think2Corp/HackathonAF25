---
hide:
  - path
---

# ActionHelper Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class ActionHelper {
  public class GenericResultWrapper {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='Result object as JSON string')
    public String resultObject;

    public GenericResultWrapper(String message, Object resultObject) {
      this.message = message;
      this.resultObject = resultObject != null ? JSON.serialize(resultObject) : null;
    }
  }

  public class QueryWrapper {
    @InvocableVariable(required=true description='Name to search for')
    public String name;
  }
}

```

## Classes

### GenericResultWrapper Class

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

##### `resultObject`

`INVOCABLEVARIABLE`

###### Signature

```apex
public resultObject
```

###### Type

String

#### Constructors

##### `GenericResultWrapper(message, resultObject)`

###### Signature

```apex
public GenericResultWrapper(String message, Object resultObject)
```

###### Parameters

| Name         | Type   | Description |
| ------------ | ------ | ----------- |
| message      | String |             |
| resultObject | Object |             |

### QueryWrapper Class

#### Fields

##### `name`

`INVOCABLEVARIABLE`

###### Signature

```apex
public name
```

###### Type

String
