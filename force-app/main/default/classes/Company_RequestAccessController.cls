public class Company_RequestAccessController {
    @AuraEnabled
    public static UserRecordAccess getUserRecordAccess(Id recordId) {
        return [Select RecordId, HasEditAccess from UserRecordAccess WHERE UserId = :UserInfo.getUserId() and RecordId = :recordId];
    }
    
    @AuraEnabled
    public static ProcessInstance[] getProcessInstance(Id recordId) {
        ProcessInstance[] pa = new List<ProcessInstance>();
        pa = [Select Id, TargetObjectId, CreatedBy.Name from ProcessInstance WHERE Status = 'Pending' AND TargetObjectId = :recordId]; 
        return pa;
        
    }

}