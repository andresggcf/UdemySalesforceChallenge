
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
}