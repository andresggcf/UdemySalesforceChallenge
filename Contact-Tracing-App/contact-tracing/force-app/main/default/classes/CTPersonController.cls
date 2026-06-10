@SuppressWarnings('PMD')
public class CTPersonController { //NOPMD

    /**
     * @return String
     */

    public static string getToken(String mobileNumber){
        //Genereate MD5 Hash
        Blob targetBolb = Blob.valueOf(mobileNumber);
        Blob hash = Crypto.generateDigest('MD5', targetBolb);


        // Get the string value of Hash blob
        return EncodingUtil.base64Encode(hash);
    }

    /**
     * @return List<Person__c>
     */

    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC LIMIT 100]; //NOPMD
    }

    public List<Person__c> searchPeople (String searchTerm){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c //NOPMD
        FROM Person__c 
        WHERE Name LIKE :'%'+searchTerm+'%' 
        OR Mobile__c LIKE :'%'+searchTerm+'%' 
        OR Token__c LIKE :'%'+searchTerm+'%'
        ORDER BY Status_Update_Date__c DESC ]; //NOPMD

    }

    /**
     * @return Person__c
     */

    public static Person__c getPersonById (String personId){
        List <Person__c> personList = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c //NOPMD
        FROM Person__c
        WHERE Id = :personId]; //NOPMD

        if(personList.size() > 0){
            return personList[0];
        } else {
            return null;
        }
    }

    /**
     * Challenge 7
     * Method that returns the count of people with each health status.
     * @return Map<String, Integer>
     */

     public static Map<String, Integer> getHealtsStatusCount(){
        Map<String, Integer> healthCountMap = new Map<String, Integer>();

        for (AggregateResult ar :  [SELECT Health_Status__c, COUNT(Id) total 
                                    FROM Person__c 
                                    GROUP BY Health_Status__c]){ 
            String healthStatus = String.valueOf(ar.get('Health_Status__c'));
            Integer peopleCount = Integer.valueOf(ar.get('total'));

            healthCountMap.put(healthStatus, peopleCount);
        }

        return healthCountMap;
     }

     public static Set<Id> getCohabitants(Set<Id> personIds){
        Set<Id> cohabitantIds = new Set<Id>();
        List<String> healthStatuses = new List<String>{'Red', 'Orange'};

        for (People_Tracing__c pt : [SELECT Id, Person_1__c, Person_2__c 
        FROM People_Tracing__c 
        WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
        AND Contact_Type__c = 'Cohabitant'
        AND (Person_1__r.Health_Status__c NOT IN :healthStatuses OR Person_2__r.Health_Status__c NOT IN :healthStatuses)]) //NOPMD
        {
            if(personIds.contains(pt.Person_1__c)){
                cohabitantIds.add(pt.Person_2__c);
            } else {
                cohabitantIds.add(pt.Person_1__c);
            }
        }

        return cohabitantIds;
     }

    public static Set<Id> getNeighbors(Set<Id> personIds){
        Set<Id> neighborIds = new Set<Id>();

        for (People_Tracing__c pt : [SELECT Id, Person_1__c, Person_2__c 
        FROM People_Tracing__c 
        WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
        AND Contact_Type__c = 'Neighbor'
        AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')]) //NOPMD
        {
            if(personIds.contains(pt.Person_1__c)){
                neighborIds.add(pt.Person_2__c);
            } else {
                neighborIds.add(pt.Person_1__c);
            }
        }

        return neighborIds;
     }
}