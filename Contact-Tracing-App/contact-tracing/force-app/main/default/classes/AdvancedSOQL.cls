@SuppressWarnings('PMD')
public with sharing class AdvancedSOQL {

    /**
     * GROUPBY specifies a group of records instead of processing many 
     * individual records.
     */
    public void groupByClause(){ 
        List<AggregateResult> simpleCount = [SELECT COUNT(Id) FROM Opportunity];
        List<AggregateResult> groupedCount = [SELECT StageName, COUNT(Id) FROM Opportunity GROUP BY StageName];
        List<AggregateResult> groupedCount2 = [SELECT StageName, COUNT(Id), MAX(Amount), AVG(Amount) FROM Opportunity GROUP BY StageName];

        System.debug('SELECT COUNT(Id) FROM Opportunity' + simpleCount);
        System.debug('SELECT StageName, COUNT(Id) FROM Opportunity GROUP BY StageName' + groupedCount);
        System.debug('SELECT StageName, COUNT(Id), MAX(Amount), AVG(Amount) FROM Opportunity GROUP BY StageName' + groupedCount2);
  
    }

    /**
     * HAVING is an optional clause that can be userd in SOQL to filter results that
     * aggregate functions return (similar to WHERE).
     * E.G Group by stagename whenre the sum of the Amount is greater that 500k
     * Select StageName, SUM(Amount) FROM Opportunity GROUP BY StageName HAVING SUM(Amount) > 500000;
     */

     public void havingClause(){
        List<AggregateResult> results = [SELECT StageName, SUM(Amount) totalAmount FROM Opportunity GROUP BY StageName HAVING SUM(Amount) > 500000];
        System.debug(results);

        //Minimizing heapsize
        for( AggregateResult result : [SELECT StageName, SUM(Amount), MIN(Amount), MAX(Amount) FROM Opportunity GROUP BY StageName HAVING SUM(Amount) > 500000] ) 
        {
            System.debug('StageName: ' + result.get('StageName') + ' Max Amount: ' + result.get('expr0'));
        }
    }
}