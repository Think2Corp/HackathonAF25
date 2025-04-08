@isTest
private class GetChallengesTest {
  @isTest
  static void testGetChallenges_NoInput() {
    // Arrange
    List<GetChallenges.ChallengeQueryInput> inputs = new List<GetChallenges.ChallengeQueryInput>();

    // Act
    List<GetChallenges.ChallengeResultWrapper> results = GetChallenges.getChallenges(
      inputs
    );

    // Assert
    System.assertEquals(1, results.size());
    System.assertEquals('No input provided', results[0].message);
    System.assertEquals(0, results[0].challenges.size());
  }

  @isTest
  static void testGetChallenges_NoResults() {
    // Arrange
    GetChallenges.ChallengeQueryInput input = new GetChallenges.ChallengeQueryInput();
    input.status = 'NonExistentStatus';
    List<GetChallenges.ChallengeQueryInput> inputs = new List<GetChallenges.ChallengeQueryInput>{
      input
    };

    // Act
    List<GetChallenges.ChallengeResultWrapper> results = GetChallenges.getChallenges(
      inputs
    );

    // Assert
    System.assertEquals(1, results.size());
    System.assertEquals('No challenges found', results[0].message);
    System.assertEquals(0, results[0].challenges.size());
  }

  @isTest
  static void testGetChallenges_WithResults() {
    // Arrange
    Challenge__c challenge = new Challenge__c(
      Name = 'Test Challenge',
      Status__c = 'Draft',
      Participants__c = 'John Doe'
    );
    insert challenge;

    GetChallenges.ChallengeQueryInput input = new GetChallenges.ChallengeQueryInput();
    input.status = 'Draft';
    input.participantIdentifier = 'John';
    List<GetChallenges.ChallengeQueryInput> inputs = new List<GetChallenges.ChallengeQueryInput>{
      input
    };

    // Act
    List<GetChallenges.ChallengeResultWrapper> results = GetChallenges.getChallenges(
      inputs
    );

    // Assert
    System.assertEquals(1, results.size());
    System.assertEquals(
      'Challenges retrieved successfully',
      results[0].message
    );
    System.assertEquals(1, results[0].challenges.size());
    System.assertEquals('Test Challenge', results[0].challenges[0].Name);
  }

  @isTest
  static void testGetChallenges_FilterOnParticipants() {
    // Arrange
    Challenge__c challenge1 = new Challenge__c(
      Name = 'Challenge 1',
      Status__c = 'Draft',
      Participants__c = 'John Doe, Jane Smith'
    );
    Challenge__c challenge2 = new Challenge__c(
      Name = 'Challenge 2',
      Status__c = 'Draft',
      Participants__c = 'Alice Smith, Bob Brown'
    );
    insert new List<Challenge__c>{ challenge1, challenge2 };

    GetChallenges.ChallengeQueryInput input = new GetChallenges.ChallengeQueryInput();
    input.participantIdentifier = 'john';
    List<GetChallenges.ChallengeQueryInput> inputs = new List<GetChallenges.ChallengeQueryInput>{
      input
    };

    // Act
    List<GetChallenges.ChallengeResultWrapper> results = GetChallenges.getChallenges(
      inputs
    );

    // Assert
    System.assertEquals(1, results.size());
    System.assertEquals(
      'Challenges retrieved successfully',
      results[0].message
    );
    System.assertEquals(1, results[0].challenges.size());
    System.assertEquals('Challenge 1', results[0].challenges[0].Name);
  }
}
