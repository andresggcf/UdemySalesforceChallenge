@SuppressWarnings('PMD')
public with sharing class AggregateSOQL { 
    /*
    AVG()
    COUNT()
    MIN()
    MAX()
    SUM()
    **/

    /**
     * 
     */
    public List<AggregateResult> countRecords(){ 
        List<AggregateResult> countName = [SELECT COUNT(Name) FROM Account];
        List<AggregateResult> countDistinct = [SELECT COUNT_DISTINCT(Name) FROM Account]; 

        return countDistinct;
    }

     /**
     * field needs to be a number.
     */
    public List<AggregateResult> sumAmount(){ 
        List<AggregateResult> oppSum = [SELECT SUM(Amount) FROM Opportunity];
    
        return oppSum;
    }
}