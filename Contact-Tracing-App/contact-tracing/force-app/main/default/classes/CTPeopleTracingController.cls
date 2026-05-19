public with sharing class CTPeopleTracingController {
    public CTPeopleTracingController() { //NOPMD

    }

    /**
     * Returns list of people tracing records matching record Id value
     */
    public static List<People_Tracing__c> getTraces (String personId){
        return [SELECT Id, contact_date__c, person_1__c, person_2__c //NOPMD
        FROM People_Tracing__c 
        WHERE Person_1__c = :personId 
            OR Person_2__c = :personId
        ORDER BY contact_date__c DESC];
    }

    public static List<People_Tracing__c> checkDuplicates (List <People_Tracing__c> newPeopleTraces){ //NOPMD
        //Store unique ids
        Set<Id> personIds = new Set<Id>();
        for (People_Tracing__c trace : newPeopleTraces){
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }

        //List duplicate records
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();

        //Mapof id and set<id>
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();

        //Query Existing Records
        List<People_Tracing__c> existingRecords = [SELECT Id, person_1__c, Person_2__c //NOPMD
                                                    FROM People_Tracing__c 
                                                    WHERE Person_1__c IN :personIds
                                                    OR Person_2__c IN :personIds];

        if(existingRecords != null && existingRecords.size() > 0){
            for (People_Tracing__c trace : existingRecords){
                if(!mapOfExistingRecords.containsKey(trace.Person_1__c)){
                    mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                }
                
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                if(!mapOfExistingRecords.containsKey(trace.Person_2__c)){
                    mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
                }

                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
            }

            //loop over existing records to find duplicates.
            for (People_Tracing__c trace : newPeopleTraces){
                if((mapOfExistingRecords.containsKey(trace.Person_1__c) 
                    && mapOfExistingRecords.get(trace.person_1__c).contains(trace.person_2__c)) 
                    || (mapOfExistingRecords.containsKey(trace.Person_2__c) 
                    && mapOfExistingRecords.get(trace.person_2__c).contains(trace.person_1__c))){
                    duplicates.add(trace);
                }
            }
        }
        return duplicates;
    }
} 