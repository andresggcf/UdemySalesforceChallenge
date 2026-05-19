public with sharing class CTLocationTracingController {
    /**
     * @return List<Location__c>
     */
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Location__c, Person__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c//NOPMD
        FROM Location_Tracing__c 
        WHERE Location__c = :locationId 
        ORDER BY Visit_Date__c DESC NULLS LAST];
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds (Set<Id> personIds){
        return [SELECT Id, Location__c, Person__c //NOPMD
        FROM Location_Tracing__c 
        WHERE Person__c IN :personIds 
        AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds (Set<Id> locationIds){
        return [SELECT Id, Location__c, Person__c //NOPMD
        FROM Location_Tracing__c 
        WHERE Location__c IN :locationIds 
        AND Person__r.Health_Status__c = 'Green'
        AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        //Store unique ids
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c lt : newLocationTraces){
            locationIds.add(lt.Location__c);
            personIds.add(lt.Person__c);
        }

        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();
        
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c //NOPMD
        FROM Location_Tracing__c 
        WHERE Location__c IN :locationIds
        AND Person__c IN :personIds];

        //List of duplicate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

        if(existingRecords != null && existingRecords.size() > 0){
            for (Location_Tracing__c trace: existingRecords){
                if(!mapOfExistingRecords.containsKey(trace.Location__c)){
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }

                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }
            for (Location_Tracing__c trace: newLocationTraces){
                //check for location id, if item found in map, check for person id in set
                if(mapOfExistingRecords.containsKey(trace.Location__c)
                    && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                        duplicates.add(trace);
                }
            }

        }
        return duplicates;
    }

}