@isTest(seeAllData=true)
public class MAP_EligibleAvtivitiesMatrixCtrl_Test {
    public static TestMethod void testActivityMatrixMethod(){ 
        User partnerUser = [Select Id,AccountId,ProfileId,Account.Primary_Member__c,Account.Pilot_Agreement_Term_Date__c,Account.Pilot_Agreement_Ids__c,isActive,ContactId From User Where isActive=true AND ProfileId=:Label.Rackspace_Partners_Profile AND AccountId!=null AND Account.Primary_Member__c!=null Limit 1];
        Contact con = [Select Id From Contact Where ID =: partnerUser.Account.Primary_Member__c  Limit 1];
        USer pUser = [Select Id,ContactID from User Where ContactID=:con.Id];
        List<ID> ids = new List<ID>();
        List<Id> removeIds = new List<Id>();
         Map<Id,ContentDocument> contentDocumentList = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where Title=: 'Eligible Activities Matrix']);
        for(ContentDistribution cd :[SELECT Id,ContentDocumentId From ContentDistribution Where ContentDocumentID In : contentDocumentList.keySet()])
      ids.add(cd.id);
        removeIds = ids;
        //System.runAs(pUser){
            MAP_EligibleAvtivitiesMatrixController.getPDFDocument();
        //}
        }
}