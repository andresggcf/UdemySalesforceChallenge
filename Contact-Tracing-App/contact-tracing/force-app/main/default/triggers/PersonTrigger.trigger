trigger PersonTrigger on Person__c (before insert, before update) {

    PersonTriggerHandler handler = new PersonTriggerHandler(Trigger.new, Trigger.oldMap);

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            handler.beforeInsert();
        }

        if(Trigger.isUpdate){
            handler.beforeUpdate();
        }
    }

}