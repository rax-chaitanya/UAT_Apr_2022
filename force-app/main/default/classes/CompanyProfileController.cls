public without sharing class CompanyProfileController {
    // Added by: Chiranjeevi Gogulakonda,TechMahindra Ltd.
    //SFDC-3811 start
    //SFDC-3941 start
    Public Class leadDataWrapper{
        @AuraEnabled public Decimal LeadsCreated {get;set;}
        @AuraEnabled public Decimal LeadsConverted {get;set;}    
    }
    //this method used to disply the Lead Summery deta on partner accounts detail page
    @AuraEnabled
    public static leadDataWrapper getLeadData(id companyid){
        //system.debug('Lead companyid>>>'+companyid);
        List<Lead> leadsCreatedList = new list<Lead>();
        List<Lead> leadsConvertedList = new list<Lead>();
        map<string, Decimal> leadSummarymap = new map<string, Decimal>();
        Decimal ConvertedPercentage;
        
        /*list<lead> testleadlist = [SELECT Id,ConvertedDate,CreatedDate,Partner_Company_Name__c FROM Lead WHERE
CreatedDate = THIS_FISCAL_YEAR AND Partner_Company_Name__c =: companyid limit 50000];
system.debug('testleadlist>>>'+testleadlist.size());
*/
        for(Lead leadE :[SELECT Id,ConvertedDate,CreatedDate,Partner_Company_Name__c FROM Lead WHERE CreatedDate = THIS_FISCAL_YEAR AND Partner_Company__c =: companyid ]){
            if(leadE.CreatedDate !=null){
                leadsCreatedList.add(leadE);
                leadSummarymap.put('LeadCreated',leadsCreatedList.size());
            }
        }
        for(Lead leadE :[SELECT Id,ConvertedDate,CreatedDate,Partner_Company_Name__c FROM Lead WHERE ConvertedDate= THIS_FISCAL_YEAR AND Partner_Company__c =: companyid ]){
            if(leadE.ConvertedDate !=null){
                leadsConvertedList.add(leadE);
                leadSummarymap.put('LeadConverted',leadsConvertedList.size());  
            }          
        }
        leadDataWrapper leadWrapper = new leadDataWrapper();
        if((leadSummarymap.containsKey('LeadCreated') && leadSummarymap.get('LeadCreated') != null) && leadSummarymap.get('LeadCreated') > 0.0){
            leadWrapper.LeadsCreated = leadSummarymap.get('LeadCreated');
        }else {
            leadWrapper.LeadsCreated = 0;
        }
        if((leadSummarymap.containsKey('LeadConverted') && leadSummarymap.get('LeadConverted') != null && leadSummarymap.get('LeadConverted') > 0.0) && leadSummarymap.get('LeadCreated') != null){
            ConvertedPercentage=((leadSummarymap.get('LeadConverted')/leadSummarymap.get('LeadCreated'))*100);
            leadWrapper.LeadsConverted = ConvertedPercentage.setScale(2, RoundingMode.HALF_UP);
            //system.debug('$$$$$$$'+leadWrapper.LeadsConverted);
        }else {
            leadWrapper.LeadsConverted = 0;
        }
        return leadWrapper;
    }
    
    //SFDC-3811 end
    
    //SFDC-3823 start
    //Developer: Samba, Techmahindra
    Public Class opportunityDetaWrapper{
        @AuraEnabled public double pipelinesCeated;
        @AuraEnabled public double openPipeLines;
        @AuraEnabled public double bookedlines;
    }
    //this method used to disply the Opportunity Summery deta on partner accounts detail page
    @AuraEnabled
    public static opportunityDetaWrapper getOpportunityDeta(id companyid){
        //system.debug('companyid>>>>>>'+companyid);
        List<Opportunity> createdOpList = new list<Opportunity>();
        list<opportunity> bookings= new list<opportunity>();
        List<Opportunity> openList = new list<Opportunity>();
        map<string, double> opOummerymap = new map<string, double>();
        //map<string, integer> opOummerymap = new map<string, integer>();
        double createdOpamount= 0.00;
        double openOpamount= 0.00;
        double bookingsOpamount= 0.00;
        //Start of SFDC-4446
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        Date orgFiscalYear = Date.newinstance(system.today().year(), orgFiscalMonth, 1);
          //END of SFDC-4446
        //system.debug('fiscalyear'+orgFiscalYear);
        Set<Id> OptyId = new Set<Id>();                            
        //List<Partner_Role__c>  RoleList = [select id,Role__c,Opportunity__c,Partner_Company__c from Partner_Role__c where role__c = 'Source' and CreatedDate = THIS_FISCAL_YEAR];
        for(Partner_Role__c Role: [select id,Role__c,Opportunity__c,Partner_Company__c from Partner_Role__c where role__c = 'Source' AND Opportunity__c != Null AND Opportunity__r.Partner_Company__c =: companyid  ]){
            if(Role.Opportunity__c != Null){
                OptyId.add(Role.Opportunity__c);    
                
            }
        }                  
        //Removed closed=This_fiscal_year from query for SFDC-4466
        for(Opportunity opty : [select Id,Name,amount,stageName,CreatedDate,closedate from Opportunity where  (CreatedDate = THIS_FISCAL_YEAR or closedate= THIS_FISCAL_YEAR) and Id =: OptyId and Partner_Company__c =:companyid]){
            createdOpList.add(opty);
            //Updated below if Condition for SFDC-4446
            if(opty.amount != null && opty.CreatedDate.year() == orgFiscalYear.year()){
                //system.debug('fiscalyearopp'+opty.CreatedDate);
                //system.debug('opty.amount>>>>>>'+opty.id+'='+opty.amount);
                createdOpamount = createdOpamount + opty.amount;              
            }                        
            //Updated below if Condition for SFDC-4446
            if(opty.StageName != 'Closed Won' && opty.StageName !='Closed Lost' && opty.amount != null && opty.closedate.year() == orgFiscalYear.year() ){
                openList.add(opty);
                openOpamount = openOpamount + opty.amount;
                //opOummerymap.put('PipelineOpen',openList.size());
            }
            if(opty.StageName == 'Closed Won' && opty.amount != null){
                bookings.add(opty);
                bookingsOpamount = bookingsOpamount + opty.amount;
                //opOummerymap.put('bookings',bookings.size());
            }
        }
        opOummerymap.put('PipelineCreated',createdOpamount);
        opOummerymap.put('PipelineOpen',openOpamount);
        opOummerymap.put('bookings',bookingsOpamount);
        //system.debug('Total amount>>>>>>'+createdOpamount);
        
        opportunityDetaWrapper optydetaWrapper = new opportunityDetaWrapper();
        //Updated below if Condition for SFDC-4446
        if((opOummerymap.containsKey('PipelineCreated') && opOummerymap.get('PipelineCreated') != null) && ( opOummerymap.get('PipelineCreated') > 0 || opOummerymap.get('PipelineCreated') < 0 )){
            optydetaWrapper.pipelinesCeated = opOummerymap.get('PipelineCreated');
        }else {
            optydetaWrapper.pipelinesCeated = 0;
        }
        if((opOummerymap.containsKey('PipelineOpen') && opOummerymap.get('PipelineOpen') != null) && opOummerymap.get('PipelineOpen') > 0){
            optydetaWrapper.openPipeLines = opOummerymap.get('PipelineOpen');
        }else {
            optydetaWrapper.openPipeLines = 0;
        }
        //Updated below if Condition for SFDC-4446
        if((opOummerymap.containsKey('bookings') && opOummerymap.get('bookings') != null) && ( opOummerymap.get('bookings') > 0 || opOummerymap.get('bookings') < 0 )){
            optydetaWrapper.bookedlines = opOummerymap.get('bookings');
        }else {
            optydetaWrapper.bookedlines = 0;
        }
        return optydetaWrapper;
    }
    //SFDC-3823 end
    //SFDC-3941 end
    @AuraEnabled
    public static Boolean checkPrimary(){
        User puser = [Select name,AccountId,Account.Primary_Member__c,id,contactid from User where id =: UserInfo.getUserId() limit 1];
        if(puser.Account.Primary_Member__c == puser.contactid)
            return false;
        else 
            return true;
    }
    @AuraEnabled
    public static Account getCompanyProfile(){
        Account company=new Account();
        User puser = [Select name,AccountId,id,contactid from User where id =: UserInfo.getUserId() limit 1];
        if(puser.AccountId!=Null){
            company = [Select Id,Name,BillingCity,BillingState,BillingCountry,Website,ParentId,Description,Membership__c,Partner_Solution__c,Industry,Partner_Product__c 
                       from Account where id = : puser.AccountId limit 1];
        }
        if(company!=null)
            return company;            
        else 
            return null;            
    }
    
    @AuraEnabled
    public static String setCompanyProfile(String description,String solution,String product,String industry,String country,Account acc){       
        acc.Description = description;    
        acc.Partner_Solution__c = solution;            
        acc.Partner_Product__c = product;  
        acc.Industry = industry; 
        acc.BillingCountry = country;   
        //update acc;
        try{
            update acc;
            return 'Entered values are saved sucessfully';
        }catch(Exception e){
            return 'Unable to update the values. Please contact Partner HelpDesk';
        }
    }
    @AuraEnabled        
    public static Object getPickListValuesIntoList(String objectType, String country,String partnerSolution, String partnerProduct, String industry ){
        Map<String,Object> resultMap = new Map<String,Object>();
        Account companydetails=new Account();
        User partnerUser = [Select id,ContactId,AccountId From User Where Id=: UserInfo.getUserId()];
        if(partnerUser .AccountId!=Null){
            companydetails = [Select BillingCountry,Partner_Solution__c,Partner_Product__c,Industry,Membership_Level__c from Account where id = : partnerUser.AccountId ];
        }
        //Account companydetails = [Select BillingCountry,Partner_Solution__c,Partner_Product__c,Industry,Membership_Level__c from Account where id = : company.AccountId ];
        resultMap.put('companyInformation',companydetails);
        resultMap.put('pCountry',getPickListValues(objectType,country,companydetails.BillingCountry));
        resultMap.put('pSolution',getPickListValues(objectType,partnerSolution,companydetails.Partner_Solution__c));
        resultMap.put('pProduct',getPickListValues(objectType,partnerProduct,companydetails.Partner_Product__c));
        resultMap.put('pIndustry',getPickListValues(objectType,industry,companydetails.Industry));
        //resultMap.put('Accmembership',getPickListValues(objectType,pAccmembership,companydetails.Membership_Level__c));
        return resultMap;
    }
    @AuraEnabled        
    public static List<String> getPickListValues(String objectValue, String fieldValue, String existValue){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectValue);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fieldValue).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(pickListVal.getLabel()!=existValue)
                pickListValuesList.add(pickListVal.getLabel());
        }
        if(String.isNotBlank(existValue)){
            pickListValuesList.add(0,existValue);
            //pickListValuesList.add('--None--');
            
        }else{
            pickListValuesList.add(0,'--None--');
            
        }
        
        return pickListValuesList; 
    }
    //SFDC 3806 start 
    //Developer: Samba
    @AuraEnabled 
    public static list<ContentVersion> getAllFiles(){
        list<ContentVersion> versionlist = new list<ContentVersion>();
        User pUser = [Select id,name,AccountId,contactid from User where id =: userinfo.getUserId()];
        List<Account> company = [Select Id,Name,Membership_Level__c,ParentId,Membership__c from Account where 
                                 Membership_Level__c!= null and id =: pUser.AccountId limit 1]; 
        if(!company.isEmpty()){
            versionlist=[SELECT Id,Membership_Level__c,Title,FileType,
                         ContentDocumentid FROM ContentVersion where 
                         Membership_Level__c!= null and Membership_Level__c =: company[0].Membership_Level__c ORDER BY FileType ASC];
        }        
        return versionlist;
    }
    //SFDC 3806 end
}