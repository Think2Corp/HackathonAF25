public with sharing class GetChallenges {
  public GetChallenges() {
  }

  public class ChallengeQueryInput {
    @InvocableVariable(
      description='The Challenge Status of the Challenge to search for'
    )
    public String status;
    @InvocableVariable(
      description='The Start Date of the Challenge to search for'
    )
    public Date startDate;
    @InvocableVariable(
      description='The End Date of the Challenge to search for'
    )
    public Date endDate;
    @InvocableVariable(
      description='The Challenge ID of the Challenge to search for'
    )
    public String id;
    @InvocableVariable(description='The Name of the Challenge to search for')
    public String name;
    @InvocableVariable(description='The Manager of the Challenge to search for')
    public String manager;
    @InvocableVariable(
      description='The Role of the Participant of the Challenge to search for'
    )
    public String participantRole;
    @InvocableVariable(
      description='The Name of the Participant of the Challenge to search for'
    )
    public String participantName;
  }

  public class ChallengeResultWrapper {
    @InvocableVariable(description='List of Challenge Objects found')
    public List<Challenge__c> challenges;
    @InvocableVariable(description='Result message of the search')
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
    List<Challenge__c> filteredChallenges = ChallengeHelper.filterChallengesByParticipant(
      challenges,
      queryInput.participantRole,
      queryInput.participantName
    );

    if (filteredChallenges.isEmpty()) {
      results.add(
        new ChallengeResultWrapper(
          new List<Challenge__c>(),
          'No challenges found'
        )
      );
    } else {
      results.add(
        new ChallengeResultWrapper(
          filteredChallenges,
          'Challenges retrieved successfully'
        )
      );
    }

    return results;
  }
}
