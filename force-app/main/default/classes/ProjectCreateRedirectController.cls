public class ProjectCreateRedirectController {
    
    Public String recordTypeID{get;set;}
    Public String recordTypeName;
    
    public ProjectCreateRedirectController(ApexPages.StandardController controller){
        recordTypeID = Apexpages.currentPage().getParameters().get(Label.RecordTypeLabel);
        System.debug('recordTypeID '+recordTypeID);
        if(String.isBlank(recordTypeID) || recordTypeID == null){
            RecordTypeInfo rti= getDefaultRecordTypeId();
            recordTypeID = rti.recordTypeId;
            recordTypeName = rti.Name;
        }else
        recordTypeName = [Select ID, Name from RecordType where id=:recordTypeID].Name;
    }
    
    public pageReference redirectPage(){
        if(recordTypeName == Label.ProjectRecordTypeEMEAProServces){
            PageReference CustomEditPage = new PageReference('/apex/ProjectEMEAProServPage').setRedirect(true);
            CustomEditPage.getParameters().put(Label.RecordTypeLabel,recordTypeID);
            return CustomEditPage;
        }
        PageReference StandardPage = new PageReference(Label.ProjectRedirectUrl+recordTypeID).setRedirect(true);
        // StandardPage = new PageReference('/a1f/e?retURL=%2Fa1f%2Fo&RecordType='+recordTypeID);
        StandardPage.getParameters().put('nooverride', '1');
        return StandardPage;
        
        
    }
    
    RecordTypeInfo getDefaultRecordTypeId(){
        Schema.DescribeSObjectResult dsr = Project__c.SObjectType.getDescribe();
        Schema.RecordTypeInfo defaultRecordType;
        for(Schema.RecordTypeInfo rti : dsr.getRecordTypeInfos()) {
            if(rti.isDefaultRecordTypeMapping()) {
                defaultRecordType = rti;
            }
        }
        return defaultRecordType; 
    }
}