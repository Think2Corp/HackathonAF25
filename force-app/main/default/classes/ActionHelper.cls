public with sharing class ActionHelper {
  public ActionHelper() {
  }

  public class GenericResultWrapper {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='Result object as JSON string')
    public String resultObject;
    @InvocableVariable(description='List of User sObjects')
    public List<User> userList;

    public GenericResultWrapper(String message, Object resultObject) {
      this.message = message;
      this.resultObject = resultObject != null
        ? JSON.serialize(resultObject)
        : null;
    }

    // Overloaded constructor to initialize userList
    public GenericResultWrapper(
      String message,
      Object resultObject,
      List<User> userList
    ) {
      this.message = message;
      this.resultObject = resultObject != null
        ? JSON.serialize(resultObject)
        : null;
      this.userList = userList;
    }
  }

  public class QueryWrapper {
    @InvocableVariable(required=true description='Name to search for')
    public String name;
  }
}
