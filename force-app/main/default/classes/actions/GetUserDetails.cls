public with sharing class GetUserDetails {
  public GetUserDetails() {
  }

  public class Input {
    @InvocableVariable(required=true description='Name to search for')
    public String name;
  }

  public class Output {
    @InvocableVariable(description='Result message')
    public String message;
    @InvocableVariable(description='Result object as JSON string')
    public String resultObject;
    @InvocableVariable(description='List of User sObjects')
    public List<User> userList;

    public Output(String message, Object resultObject, List<User> userList) {
      this.message = message;
      this.resultObject = resultObject != null ? JSON.serialize(resultObject) : null;
      this.userList = userList;
    }
  }

  @InvocableMethod(label='Get User Details' description='Query user details by name')
  public static List<Output> getUserDetails(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output('No input provided', null, null));
      return results;
    }

    Input input = inputList[0];
    List<User> users = UserHelper.queryUsersByName(input.name);

    if (users.isEmpty()) {
      results.add(new Output('No users found', null, null));
    } else {
      results.add(new Output('Users found', null, users));
    }

    return results;
  }
}
