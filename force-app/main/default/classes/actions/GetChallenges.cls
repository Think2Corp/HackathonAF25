public with sharing class GetChallenges {
  public GetChallenges() {
  }

  public class ChallengeQueryInput {
    @InvocableVariable(description='Challenge Status')
    public String status;
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
    @InvocableVariable(description='Participant Name or Role')
    public String participantIdentifier;
  }

  public class ChallengeResultWrapper {
    @InvocableVariable(description='List of Challenge Objects')
    public List<Challenge__c> challenges;
    @InvocableVariable(description='Result message')
    public String message;

    public ChallengeResultWrapper(
      List<Challenge__c> challenges,
      String message
    ) {
      this.challenges = challenges;
      this.message = message;
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
      results.add(
        new ChallengeResultWrapper(
          new List<Challenge__c>(),
          'No input provided'
        )
      );
      return results;
    }

    ChallengeQueryInput queryInput = queryInputList[0];
    List<Challenge__c> challenges = ChallengeHelper.queryChallenges(
      queryInput.status,
      queryInput.startDate,
      queryInput.endDate,
      queryInput.id,
      queryInput.name,
      queryInput.manager
    );

    // Delegate participant filtering to ChallengeHelper
    challenges = ChallengeHelper.filterChallengesByParticipant(
      challenges,
      queryInput.participantIdentifier
    );

    if (challenges.isEmpty()) {
      results.add(
        new ChallengeResultWrapper(
          new List<Challenge__c>(),
          'No challenges found'
        )
      );
    } else {
      results.add(
        new ChallengeResultWrapper(
          challenges,
          'Challenges retrieved successfully'
        )
      );
    }

    return results;
  }
}
