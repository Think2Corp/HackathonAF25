public with sharing class ActionHelper {
  public ActionHelper() {
  }

  public class GenericResultWrapper {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='Result object as JSON string')
    public String resultObject;

    public GenericResultWrapper(String message, Object resultObject) {
      this.message = message;
      this.resultObject = resultObject != null
        ? JSON.serialize(resultObject)
        : null;
    }
  }

  public class QueryWrapper {
    @InvocableVariable(required=true description='Name to search for')
    public String name;
  }
}
