@isTest
public class AssignLeadsUsingAssignmentRules_Test {
    static testMethod void testPost() {
        List<Lead> leads = new List<Lead>();
        Lead l1     = new Lead(phone='12345',title='CEO',lastname='TestLN1',company='TestComp1',APN_CRM_Unique_Identifier__c='L80000');
        Lead l2     = new Lead(phone='123456',title='CEO',lastname='TestLN2',company='TestComp1',APN_CRM_Unique_Identifier__c='L90000');
        leads.add(l1);
        leads.add(l2);
        insert leads;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/LeadAssign/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        list<string> LeadAPNIds = new list<string>();
        string test ='L364316';
        string test1='L364316';
        LeadAPNIds.add(test);
        LeadAPNIds.add(test);
        AssignLeadsUsingAssignmentRules.LeadAssign(LeadAPNIds);
    }
    
}