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
