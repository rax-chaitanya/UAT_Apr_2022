public class NavigateCWWizardController {
    
    @AuraEnabled
    public static User getUserInfo() {
        System.debug('getting User Info');
        return [Select Id, Region__c, ProfileId from User where Id = : UserInfo.getUserId() ];
    }
    //Samba, SFDC-6367, Start
     @AuraEnabled
    public static String getRaptorURL(Id opptyId) {
     String url;
     Opportunity opptyRecord = [Select Id, Name,type, DDI__c,Contract_Received__c, Recordtype.Name from Opportunity where Id = : opptyId ];
      if(opptyRecord.Contract_Received__c==False && (Label.CACRecordTypes.contains(opptyRecord.Recordtype.Name)||(Label.opportuitygovernmentrecordtypeid.contains(opptyRecord.Recordtypeid)&& Label.GovernmentOpportunityTypes.contains(opptyRecord.Type))) && Label.CloudOpportunityTypes.contains(opptyRecord.type)){
     //  if(opptyRecord.Contract_Received__c==False && Label.CACRecordTypes.contains(opptyRecord.Recordtype.Name)&& Label.CloudOpportunityTypes.contains(opptyRecord.type)){
        if (UserInfo.getOrganizationId() == ProdOrgIDSetting__c.getInstance().ProdOrgID__c) {
            url = Label.Raptor_Documents;
            system.debug('Prod URL .....'+url);
        } else {
            url = Label.Raptor_Documents_Staging;
            system.debug('Staging URL .....'+url);
        }
        }
        //url = url.replace(':OPPORTUNITYID', opportunity.id);
        return url;
    }
    //Samba, SFDC-6367, end
    // Added By Shravan Godha- start
    @AuraEnabled
    public static Opportunity getLegalApprovalInfo(Id opptyId) {
        
            Opportunity opptyRecord = [Select Id, Name,Onica_Type__c, DDI__c, Type,Onica_Primary_Approval__c, Onica_Primary_Approval__r.Status__c from Opportunity where Id = : opptyId ];
            
            return opptyRecord;                    
        
    }
    // Added By Shravan Godha- End    
    // 
    // test method not be moved to prod
    @AuraEnabled
    public static boolean getUserPermission(String permissionname) {
        return  FeatureManagement.checkPermission(permissionname);

    }
    @AuraEnabled
    public static boolean checkgovtopptydetails(Id opptyId) {
     boolean check;
        system.debug('opptyId--->'+opptyId);
     Opportunity opptyRecord = [Select Id, Name,type, DDI__c,Contract_Received__c, Recordtype.Name from Opportunity where Id = : opptyId and ddi__c!=''];
      Account acc=[select id,name,recordtype.name from account where ddi__c=:opptyRecord.DDI__c and ddi__c!=''];
        if(opptyRecord.DDI__c!='' && opptyRecord.RecordType.Name == 'Government' && acc.Recordtype.name!='Government Account'){
        check=true;
        }
        return check;
    }

    
    
}