public without sharing class AgreementController {
    
    public Account company {set;get;}  
    public ContentDistribution  resellerContent{set;get;}
    public ContentDistribution  referralContent {set;get;}
    public AgreementController(){
        User u = [Select name,id,contactid,AccountId from User where id =: UserInfo.getUserId() limit 1];
        company = [Select Id,Partner_Level__c,Name,OwnerId,Contract_Signed_Date__c from Account where id = : u.AccountId limit 1];
        //reseller
        resellerContent = [SELECT DistributionPublicUrl,createdDate,ContentDownloadUrl FROM ContentDistribution where contentDocumentId =: System.Label.Reseller_AgreementId order by createdDate desc limit 1];
        
        //referral
        referralContent = [SELECT DistributionPublicUrl,createdDate,ContentDownloadUrl FROM ContentDistribution where contentDocumentId =: System.Label.US_Referral_AgreemntId order by createdDate desc limit 1];
         
        }
    
    
    public PageReference gotoPortal(){
        company.Contract_Signed_Date__c = System.Date.today();
        company.Agreed_By_Timestamp__c = System.now();
        company.Reseller_Contract_Start_Date__c = System.Date.today();
        if(company.Partner_Level__c == Label.Referral)
            company.Contract_Type__c = Label.US_Referral_Agreement;
        if(company.Partner_Level__c == Label.Reseller)
            company.Contract_Type__c = Label.US_Reseller_Agreement;
        if(company.Partner_Level__c == Label.Referral_Reseller)
            company.Contract_Type__c = Label.US_Referral_Reseller_Agreement;
        company.Agreement_Agreed_By__c = UserInfo.getUserId();
        update company;
        return new PageReference('/'+Label.PartnerPortalName);
    }
    
}