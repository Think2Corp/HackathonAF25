public with sharing class GetOpportunities {
  public class Input {
    @InvocableVariable(description='Text field specifying Opportunity Name')
    public String name;
    @InvocableVariable(description='Text field specifying the Opportunity Owner Name')
    public String owner;
    @InvocableVariable(description='Lookup field to User specifying the Opportunity Owner Id')
    public String ownerId;
    @InvocableVariable(description='Date field at the date of the opportunity has been closed')
    public Date closeDate;
    @InvocableVariable(
      description='Picklist list specifying the opportunity type\nValues: \nExisting Customer - Upgrade\nExisting Customer - Replacement\nExisting Customer - Downgrade\nNew Customer'
    )
    public String type;
    @InvocableVariable(
      description='Picklist list specifying the opportunity stage\nValues in the order of progression:\nProspecting\nQualification\nNeeds Analysis\nValue Proposition\nId. Decision Makers\nPerception Analysis\nProposal/Price Quote\nNegotiation/Review\nClosed Won\nClosed Lost'
    )
    public String stage;
    @InvocableVariable(description='Boolean specifying Is Opportunity Closed')
    public Boolean isClosed;
    @InvocableVariable(description='Boolean specifying Is Opportunity Won')
    public Boolean isWon;
    @InvocableVariable(description='Date input for the start date for searching in a range of Close Date')
    public Date closeDateStart;
    @InvocableVariable(description='Date input for the end date for searching in a range of Close Date')
    public Date closeDateEnd;
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

  @InvocableMethod(
    label='Get Opportunities'
    description='- If the users asks for opportunities with a close date between a range of dates, filled the fields CloseDateStart and CloseDateEnd. CloseDateStart must be inferior to CloseDateEnd\n- if the users asks for opportunities created or modified at a specific date or between a range of dates, explain that you can&apos;t answer\n- If the user asks for Closed opportunities search with IsClosed equals true\n- If the user asks for Open opportunities search with IsClosed equals false\n- If the user asks for Lost opportunities search with IsWon equals false\n- If the user asks for Won opportunities search with IsWon equals true\n- An opportunity is considered as Advanced if the stage is Value Proposition or on the next stages'
  )
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
      queryInput.ownerId,
      queryInput.closeDate,
      queryInput.closeDateStart,
      queryInput.closeDateEnd,
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
