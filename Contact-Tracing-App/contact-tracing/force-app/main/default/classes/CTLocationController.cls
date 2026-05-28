@SuppressWarnings('PMD')
public with sharing class CTLocationController {
    /**
     * @return List<Location__c>
     */
    public static List<Location__c> getResultStatusChanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c //NOPMD
        FROM Location__c ORDER BY Status_Update_Date__c NULLS LAST LIMIT 100];
    }

    /**
     * @return List<Location__c>
     */
    public static List<Location__c> searchLocations(String searchTerm){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c //NOPMD
        FROM Location__c 
        WHERE Name LIKE :'%'+searchTerm+'%' 
        OR Pincode__c LIKE :'%'+searchTerm+'%' 
        OR Address__c LIKE :'%'+searchTerm+'%'
        ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
     * @return Location__c
     */
    public static Location__c getLocationById(String locationId){
        List <Location__c> locationList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c //NOPMD
        FROM Location__c
        WHERE Id = :locationId];

        if(locationList.size() > 0){
            return locationList[0];
        }else {
            return null;
        }
    }

    /**
     * Challenge 8
     * Query location to find the number of locations in each health status.
     * @return Map<String, Integer> map with the status and count of locations with that status.
     */
    public static Map<String, Integer> getStatusCount(){
        Map<String, Integer> statusCountMap = new Map <String, Integer>();

        for (AggregateResult ar :  [SELECT Status__c, COUNT(Id) total 
                                    FROM Location__c
                                    GROUP BY Status__c]){
            statusCountMap.put(String.valueOf(ar.get('Status__c')), Integer.valueOf(ar.get('total')));
        }

        return statusCountMap;
    }
}