public with sharing class GetOppotunitiesByCloseDateRange {
    public GetOppotunitiesByCloseDateRange() {

    }

    public class Input {
        @InvocableVariable(required=true description='Start Date for Close Date Range')
        public Date startDate;
        
        @InvocableVariable(required=true description='End Date for Close Date Range')
        public Date endDate;
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

    @InvocableMethod(label='Get Opportunities By Date Range' description='Query opportunities within a close date range')
    public static List<Output> getOpportunitiesByDateRange(List<Input> inputList) {
        List<Output> results = new List<Output>();
        
        if (inputList == null || inputList.isEmpty()) {
            results.add(new Output(new List<Opportunity>(), 'No input provided'));
            return results;
        }

        Input queryInput = inputList[0];
        
        if (queryInput.startDate > queryInput.endDate) {
            results.add(new Output(new List<Opportunity>(), 'Start date cannot be after end date'));
            return results;
        }

        String query = 'SELECT Id, Name, Owner.Name, Amount, Type, CloseDate, StageName, Difficulty__c, Description ' +
                      'FROM Opportunity ' +
                      'WHERE CloseDate >= :queryInput.startDate AND CloseDate <= :queryInput.endDate ' +
                      'ORDER BY CloseDate ASC';

        List<Opportunity> opportunities = Database.query(query);

        if (opportunities.isEmpty()) {
            results.add(new Output(opportunities, 'No opportunities found in the specified date range'));
        } else {
            results.add(new Output(opportunities, 'Successfully retrieved ' + opportunities.size() + ' opportunities'));
        }

        return results;
    }
}