@SuppressWarnings('PMD')
public with sharing class PersonTriggerHandler {
    List<Person__c> newList;
    Map<Id, Person__c> oldMap;

    public PersonTriggerHandler(List<Person__c> newList, Map<Id, Person__c> oldMap) {
        this.newList = newList;
        this.oldMap = oldMap;
    }

    public void beforeInsert(){
        for(Person__c person : newList){
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);

        }
    }

    public void beforeUpdate(){
        for(Person__c person : newList){
            if(oldMap != null && person.Health_Status__c != oldMap.get(person.Id).Health_Status__c){
                person.Status_Update_Date__c = Date.today();
            }
        }
    }
}