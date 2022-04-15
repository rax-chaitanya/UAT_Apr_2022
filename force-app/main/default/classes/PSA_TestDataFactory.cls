@isTest
public class PSA_TestDataFactory{
    static final String psa_resource_recordType_Id= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('PSA Resource').getRecordTypeId();
    public static pse__Proj__c createProject(Id oppId, Id regionId){
        pse__Proj__c project = new pse__Proj__c(
            Name = 'Test PSA Project',
            pse__Opportunity__c = oppId,
            pse__Is_Active__c = true,
            pse__Is_Billable__c = true,
            pse__Region__c = regionId
            
            
        );
        Insert project;
        return project;
    }
    
    
    public static pse__Work_Calendar__c createWorkCalendar(){
        pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c(
            pse__Friday_Hours__c = 8,
            pse__Monday_Hours__c = 8,
            pse__Saturday_Hours__c = 0,
            pse__Sunday_Hours__c = 0,
            pse__Thursday_Hours__c = 8,
            pse__Tuesday_Hours__c = 8,
            pse__Wednesday_Hours__c = 8
        );
        Insert workCalendar;
        return workCalendar;
    }
    
    public static Contact createResource(Id userId, Id regionId){
        Contact resource = new Contact(
            LastName = 'PSAResource',
            pse__Salesforce_User__c = userId,
            pse__Is_Resource__c = true,
            pse__Is_Resource_Active__c = true,
            pse__Resource_Role__c = 'Architect',
            pse__Work_Calendar__c = createWorkCalendar().Id,
            pse__Region__c = regionId,
            RecordTypeId = psa_resource_recordType_Id
        );
        insert resource;
        return resource;
    }
    
    public static pse__Assignment__c createAssignment(Id userId, Id projectId){
        pse__Assignment__c assignment = new pse__Assignment__c(
            pse__Resource__c = userId,
            pse__Project__c = projectId,
            pse__Bill_Rate__c = 100,
            pse__Is_Billable__c = true
        );
        Insert assignment;
        return assignment;
    }
    
    public static pse__Region__c createRegion(){
        pse__Region__c region = new pse__Region__c(
            Name = 'Global',
            pse__Hierarchy_Depth__c = 0
        );
        Insert region;
        return region;
    }
    
    public static pse__Permission_Control__c createPermissionControl(Id userId, Id regionId){
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(
            pse__User__c = userId,
            pse__Region__c = regionId,
            pse__Billing__c = true,
            pse__Cascading_Permission__c = true,
            pse__Compare_Project_Version__c = true,
            pse__Create_Project_Version__c = true,
            pse__Delete_Project_Version__c = true,
            pse__Edit_Task_Manager__c = true,
            pse__End_Date__c = System.today()+300,
            pse__Expense_Entry__c = true,
            pse__Expense_Ops_Edit__c = true,
            pse__Forecast_Edit__c = true,
            pse__Forecast_View__c = true,
            pse__Resource_Request_Entry__c = true,
            pse__Skills_And_Certifications_Entry__c = true,
            pse__Skills_And_Certifications_View__c = true,
            pse__Staffing__c = true,
            pse__Start_Date__c = System.today() - 100,
            pse__Team_Create__c = true,
            pse__Team_Edit__c = true,
            pse__Team_View__c = true,
            pse__Timecard_Entry__c = true,
            pse__Timecard_Ops_Edit__c = true,
            pse__View_Task_Manager__c = true
        );
        Insert permissionControl;
        return permissionControl;
    }
}