public class OnboardingHelper {
    @InvocableMethod(label='Get Learnings' description='Gets learning records from string argument')
    public static List<List<Learning__c>> getLearnings(List<String> selections) {
        String query = 'SELECT Id, Name, Expected_Hours_to_Complete__c , Must_Complete__c  FROM Learning__c ';
        //query += 'WHERE Is_Master__c = true AND (Type__c = \'Role Learning\' OR Type__c = \'Organization Learning\' '; VH-3-9-21
        query += 'WHERE (Type__c = \'Role Learning\' OR Type__c = \'Organization Learning\' ';
        if(selections.size() > 0 ){
            query += ' OR Learning_Domain__c INCLUDES (' ;
            for(Integer i = 0; i < selections.size(); i++) {
                query += '\'' + selections[i] + '\',';
            }
            query = query.removeEnd(',');
            query += ')';
            System.debug('query='+query);        
        }
        query += ')';
        List<Learning__c> learnings  = Database.query(query);
        List<List<Learning__c>> returnedLearnings = new List<List<Learning__c>>{learnings};
        System.debug(returnedLearnings);
        return returnedLearnings;
    }
    
    
    
}