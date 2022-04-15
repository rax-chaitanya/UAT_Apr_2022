trigger cloudForcastTrigger on Cloud_Forecast__c(before insert , before update, after insert, after update , after Delete ){
    if(trigger.isBefore){
        if((trigger.isInsert) || (trigger.isUpdate)){
            cloudForcastTriggerHandler handler = new cloudForcastTriggerHandler();
            handler.UserSegmentUpdate(trigger.new);
            handler.monthUpdate(trigger.new);                        
            handler.validDuplicateUser(trigger.new, trigger.oldmap);           
        }
    }
    if(trigger.isAfter){
        if((trigger.isInsert)||(trigger.isUpdate)){
            if((blockIteration.blockRecursiveCRFTriggerUpdate == false)&&(blockIteration.blockRecursiveCRFTriggerUpdateSegmentValue == false)){
                cloudForcastTriggerHandler handler = new cloudForcastTriggerHandler();           
                handler.updateTotalSegmentValue(trigger.new, trigger.oldMap); 
                
            }
        } 
        else if(trigger.isDelete){
            cloudForcastTriggerHandler handler = new cloudForcastTriggerHandler();
            handler.updateTotalSegmentValue(trigger.old, trigger.oldMap); 
        }
    }
}