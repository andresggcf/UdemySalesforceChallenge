trigger LeadTrigger on Lead (before insert, before update, after update) {

    /**
     * Context variables:
     * isBefore
     * isAfter
     * isInsert
     * isUpdate
     * etc.
     */

     /**
      * Records that are being run by a trigger are set to Read Only in after triggers.
      */
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