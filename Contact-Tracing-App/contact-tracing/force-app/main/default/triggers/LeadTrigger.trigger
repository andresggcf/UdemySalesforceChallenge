trigger LeadTrigger on Lead (before insert, before update, after update) {

    /**
     * Context variables:
     * isBefore
     * isAfter
     * isInsert
     * isUpdate
     * etc.
     * isExecuting: returns true if current context for the apex code is a trigger
     * Size: total number of records (new and old)
     * operationtype: returns an enum corresponding to the current operation.
     */

     /**
      * Records that are being run by a trigger are set to Read Only in after triggers.
      */

    System.debug( 'Trigger size: ' + Trigger.size);
    System.debug( 'isTrigger: ' + Trigger.isExecuting);
    System.debug( 'Operation type: ' + Trigger.operationType);
    for (Lead leadRecord : Trigger.new){
        if(String.isBlank(leadrecord.LeadSource) && Trigger.isBefore ){
            leadRecord.LeadSource = 'Other';
        }
        
        if ((leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted')
            && Trigger.oldMap.get(leadRecord.Id).Status == 'Open - Not Contacted'){
                leadRecord.Status.addError('You cannot directly close an open lead record.');
            }

        //Validation rule on industry.
        if (String.isBlank(leadRecord.Industry) && Trigger.isInsert){
            leadRecord.addError('The industry field cannot be blank');
        }
    }
}