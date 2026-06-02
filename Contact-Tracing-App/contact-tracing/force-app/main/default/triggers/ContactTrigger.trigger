trigger ContactTrigger on Contact (after insert, after update) {

    ContactTriggerHandler handler = new ContactTriggerHandler(Trigger.new, Trigger.oldMap);

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            handler.afterInsert();
        }
        if(Trigger.isUpdate){
            handler.afterUpdate();
        }
    }

}