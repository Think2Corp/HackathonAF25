public with sharing class GetOpportunities {
  public class Input {
    @InvocableVariable(description='Opportunity Name')
    public String name;
    @InvocableVariable(description='Opportunity Owner')
    public String owner;
    @InvocableVariable(description='Opportunity Close Date')
    public Date closeDate;
    @InvocableVariable(description='Opportunity Type')
    public String type;
    @InvocableVariable(description='Opportunity Stage')
    public String stage;
    @InvocableVariable(description='Is Opportunity Closed')
    public Boolean isClosed;
    @InvocableVariable(description='Is Opportunity Won')
    public Boolean isWon;
  }

  public class Output {
    @InvocableVariable(description='List of Opportunity Objects')
    public List<Opportunity> opportunities;
    @InvocableVariable(description='Result message')
    public String message;

    public Output(List<Opportunity> opportunities, String message) {
      this.opportunities = opportunities;
      this.message = message;
    }
  }

  @InvocableMethod(label='Get Opportunities' description='Query opportunities based on various criteria')
  public static List<Output> getOpportunities(List<Input> inputList) {
    List<Output> results = new List<Output>();
    if (inputList == null || inputList.isEmpty()) {
      results.add(new Output(new List<Opportunity>(), 'No input provided'));
      return results;
    }

    Input queryInput = inputList[0];
    List<Opportunity> opportunities = OpportunityHelper.queryOpportunities(
      queryInput.name,
      queryInput.owner,
      queryInput.closeDate,
      queryInput.type,
      queryInput.stage,
      queryInput.isClosed,
      queryInput.isWon
    );

    if (opportunities.isEmpty()) {
      results.add(new Output(new List<Opportunity>(), 'No opportunities found'));
    } else {
      results.add(new Output(opportunities, 'Opportunities retrieved successfully'));
    }

    return results;
  }
}
