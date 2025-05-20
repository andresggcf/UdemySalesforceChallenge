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
}