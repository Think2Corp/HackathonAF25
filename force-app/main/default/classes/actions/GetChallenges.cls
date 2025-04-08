public with sharing class GetChallenges {
  public GetChallenges() {
  }

  public class ChallengeQueryInput {
    @InvocableVariable(description='Challenge Status')
    public String status;
    @InvocableVariable(description='Role Name in Participants')
    public String roleName;
    @InvocableVariable(description='Start Date')
    public Date startDate;
    @InvocableVariable(description='End Date')
    public Date endDate;
    @InvocableVariable(description='Challenge ID')
    public String id;
    @InvocableVariable(description='Challenge Name')
    public String name;
    @InvocableVariable(description='Manager Name')
    public String manager;
  }

  public class ChallengeResultWrapper {
    @InvocableVariable(description='List of Challenge Objects')
    public List<Challenge__c> challenges;

    public ChallengeResultWrapper(List<Challenge__c> challenges) {
      this.challenges = challenges;
    }
  }

  @InvocableMethod(
    label='Get Challenges'
    description='Query challenges based on various criteria'
  )
  public static List<ChallengeResultWrapper> getChallenges(
    List<ChallengeQueryInput> queryInputList
  ) {
    List<ChallengeResultWrapper> results = new List<ChallengeResultWrapper>();
    if (queryInputList == null || queryInputList.isEmpty()) {
      return results;
    }

    ChallengeQueryInput queryInput = queryInputList[0];
    List<Challenge__c> challenges = ChallengeHelper.queryChallenges(
      queryInput.status,
      queryInput.roleName,
      queryInput.startDate,
      queryInput.endDate,
      queryInput.id,
      queryInput.name,
      queryInput.manager
    );

    if (!challenges.isEmpty()) {
      results.add(new ChallengeResultWrapper(challenges));
    }

    return results;
  }
}
