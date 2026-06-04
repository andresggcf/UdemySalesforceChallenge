trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {

    ContactTriggerHandler handler = new ContactTriggerHandler(Trigger.new, Trigger.oldMap);
    System.debug('trigger executed');

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            handler.afterInsert();
        }
        if(Trigger.isUpdate){
            handler.afterUpdate();
        }
        if(Trigger.isDelete){
            handler.afterDelete();
        }
        if(Trigger.isUndelete){
            handler.afterUndelete();
        }
    }

}