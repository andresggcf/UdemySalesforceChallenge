@SuppressWarnings('PMD')
public with sharing class ContactTriggerHandler {
    List<Contact> newList;
    Map<Id, Contact> oldMap;

    public ContactTriggerHandler(List<Contact> newList, Map<Id, Contact> oldMap) {
        this.newList = newList;
        this.oldMap = oldMap;
    }

    public void updateActiveContactsInAccount (){
        for(Contact cont : newList){
            [SELECT AccountId, Count(Id) FROM Contact WHERE active__c = True GROUP BY AccountId];
        }
    }

} 