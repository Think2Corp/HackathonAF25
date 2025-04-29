# clean_collections Class

<!-- Apex description -->

## Apex Code

```java
public with sharing class clean_collections {
  public class Input {
    @InvocableVariable(required=true label='String Collection' description='Collection of strings to clean')
    public List<String> stringCollection;
  }

  public class Output {
    @InvocableVariable(description='Cleaned string collection')
    public List<String> cleanedCollection;

    @InvocableVariable(description='Processing message')
    public String message;
  }

  @InvocableMethod(label='Clean String Collection' description='Removes quotes from strings in a collection')
  public static List<Output> cleanStrings(List<Input> inputs) {
    List<Output> outputs = new List<Output>();

    for (Input input : inputs) {
      Output output = new Output();
      output.cleanedCollection = new List<String>();

      if (input.stringCollection != null && !input.stringCollection.isEmpty()) {
        for (String str : input.stringCollection) {
          // Remove quotes and backslashes
          String cleaned = str.replace('\\', '').replace('"', '');
          output.cleanedCollection.add(cleaned);
        }
        output.message =
          output.cleanedCollection.size() +
          'cleaned users.' +
          ' Listing: ' +
          String.join(output.cleanedCollection, ', ');
      } else {
        output.message = 'Input collection was empty or null';
      }

      outputs.add(output);
    }

    return outputs;
  }
}

```

## Methods

### `cleanStrings(inputs)`

`INVOCABLEMETHOD`

#### Signature

```apex
public static List<Output> cleanStrings(List<Input> inputs)
```

#### Parameters

| Name   | Type              | Description |
| ------ | ----------------- | ----------- |
| inputs | List&lt;Input&gt; |             |

#### Return Type

**List&lt;Output&gt;**

## Classes

### Input Class

#### Fields

##### `stringCollection`

`INVOCABLEVARIABLE`

###### Signature

```apex
public stringCollection
```

###### Type

List&lt;String&gt;

### Output Class

#### Fields

##### `cleanedCollection`

`INVOCABLEVARIABLE`

###### Signature

```apex
public cleanedCollection
```

###### Type

List&lt;String&gt;

---

##### `message`

`INVOCABLEVARIABLE`

###### Signature

```apex
public message
```

###### Type

String
