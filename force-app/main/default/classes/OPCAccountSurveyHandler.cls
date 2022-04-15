public class OPCAccountSurveyHandler implements TriggerInterface{

public Boolean isActive()
{
if(Trigger_Manager__c.getAll().containsKey('OPCAccountSurveyTrigger')) {
return Trigger_Manager__c.getInstance('OPCAccountSurveyTrigger').Is_Active__c;
}
return false;
}

public void beforeInsert() {
    OPCAccountSurveyTriggerHelper.validateEdit((List<OPC_Account_Survey__c>)Trigger.new);
}

public void beforeUpdate() {

        OPCAccountSurveyTriggerHelper.requiredFields();
        OPCAccountSurveyTriggerHelper.validateEdit((List<OPC_Account_Survey__c>)Trigger.new);
}

public void beforeDelete() {
//empty
}

public void afterInsert()  {
//empty
}

public void afterUpdate() {
//empty
}

public void afterDelete() {
//empty
}

public void afterUndelete() {
//empty
}    
}