@SuppressWarnings('PMD')
public with sharing class ContactTriggerHandler {
    List<Contact> newList;
    Map<Id, Contact> oldMap;

    public ContactTriggerHandler(List<Contact> newList, Map<Id, Contact> oldMap) {
        this.newList = newList;
        this.oldMap = oldMap;
    }

    public void updateActiveContactsInAccount (set<Id> accountIds){
       List<AggregateResult> resultList =
            [SELECT AccountId, Count(Id) totalContacts 
            FROM Contact WHERE active__c = True AND AccountId IN :accountIds 
            GROUP BY AccountId];

            System.debug('Aggregate Result List: ' + resultList);

        if(!resultList.isEmpty()){
            List<Account> accList = new List<Account>();
            for(AggregateResult ar : resultList){
                //get account id and number of active contacts
                String accId = (String) ar.get('AccountId');
                Integer totalContacts = (Integer) ar.get('totalContacts');

                Account acc = new Account (Id = accId, active_contacts__c = totalContacts);
                System.debug('Account to update: ' + acc);
                accList.add(acc);
            }
            System.debug('Accounts to update: ' + accList);
            update accList;
        }
    }

    public void afterInsert(){
        System.debug('ContactTriggerHandler: afterInsert');
        System.debug('New List: ' + newList);
        set<Id> accountIds = new Set<Id>();
        for (Contact cont : newList) {
            if(String.isNotBlank(cont.AccountId)){
                accountIds.add(cont.AccountId);       
            }
        }
        updateActiveContactsInAccount(accountIds);
    }

    public void afterUpdate(){
        System.debug('ContactTriggerHandler: afterUpdate');
        System.debug('New List: ' + newList);
        set<Id> accountIds = new Set<Id>();
        for (Contact cont : newList) {
            if(String.isNotBlank(cont.AccountId)){
                accountIds.add(cont.AccountId);
            }
        }   
        updateActiveContactsInAccount(accountIds);
    }

    public void afterDelete(){
        System.debug('ContactTriggerHandler: afterDelete');
        System.debug('New List: ' + newList);
        set<Id> accountIds = new Set<Id>();
        for (Contact cont : oldMap.values()) {
            if(String.isNotBlank(cont.AccountId)){
                accountIds.add(cont.AccountId);
            }
        }
        updateActiveContactsInAccount(accountIds);
    }

    public void afterUndelete(){
        System.debug('ContactTriggerHandler: afterUndelete');
        System.debug('New List: ' + newList);
        set<Id> accountIds = new Set<Id>();
        for (Contact cont : newList) {
            if(String.isNotBlank(cont.AccountId)){
                accountIds.add(cont.AccountId);
            }
        }
        updateActiveContactsInAccount(accountIds);
    }

} 