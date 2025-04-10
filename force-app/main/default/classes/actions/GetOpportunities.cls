public with sharing class GetOpportunities {
  public GetOpportunities() {
  }

  public class OpportunityQueryInput {
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
  }

  public class OpportunityResultWrapper {
    @InvocableVariable(description='List of Opportunity Objects')
    public List<Opportunity> opportunities;
    @InvocableVariable(description='Result message')
    public String message;

    public OpportunityResultWrapper(List<Opportunity> opportunities, String message) {
      this.opportunities = opportunities;
      this.message = message;
    }
  }

  @InvocableMethod(label='Get Opportunities' description='Query opportunities based on various criteria')
  public static List<OpportunityResultWrapper> getOpportunities(List<OpportunityQueryInput> queryInputList) {
    List<OpportunityResultWrapper> results = new List<OpportunityResultWrapper>();
    if (queryInputList == null || queryInputList.isEmpty()) {
      results.add(new OpportunityResultWrapper(new List<Opportunity>(), 'No input provided'));
      return results;
    }

    OpportunityQueryInput queryInput = queryInputList[0];
    List<Opportunity> opportunities = OpportunityHelper.queryOpportunities(
      queryInput.name,
      queryInput.owner,
      queryInput.closeDate,
      queryInput.type,
      queryInput.stage
    );

    if (opportunities.isEmpty()) {
      results.add(new OpportunityResultWrapper(new List<Opportunity>(), 'No opportunities found'));
    } else {
      results.add(new OpportunityResultWrapper(opportunities, 'Opportunities retrieved successfully'));
    }

    return results;
  }
}
