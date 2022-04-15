@isTest(SeeAllData=false)
public class GenericConsoleMethodControllerTest{

    @TestSetUp
    static void setDataUp(){
        //TestClassUtility.setTestSetupData();
    }
    
    @isTest
     static void testMethod1(){
         String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        
            GenericConsoleMethodController obj = new GenericConsoleMethodController();
            GenericConsoleMethodController.tabInfoWrapperClass wrapObj = new GenericConsoleMethodController.tabInfoWrapperClass();
            wrapObj.parentTabId = '12345';
            wrapObj.recordId = '12345123451234512';
            wrapObj.tabId = '12345';
            wrapObj.isSubtab = false;
            
            Lead ldRec = TestClassUtility.createLeads(1)[0];
             ldRec.AnnualRevenue = 1000;
             ldrec.LeadSource = 'Webinar';
             insert ldRec;
            ID SChannelId= [SELECT Id FROM ServiceChannel Where DeveloperName='sfdc_liveagent' Limit 1].Id;
            //AgentWork awork = Test_Util.createAgentWork(caseRec.Id,UserInfo.getUserId(),SChannelId,true);
            System.debug('SChannelId'+SChannelId);
            LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
            insert liveChatVisitor;
            LiveChatTranscript liveChatTran = new LiveChatTranscript();
            liveChatTran.LiveChatVisitorId = liveChatVisitor.id;
       //     liveChatTran.status = 'In Progress';
            insert liveChatTran;
            AgentWork agentWorkObj = new AgentWork();
            agentWorkObj.WorkItemId = liveChatTran.id;
            agentWorkObj.ServiceChannelId = SChannelId;
            agentWorkObj.UserId = userinfo.getuserid();
          //  agentWorkObj.status = 'Opened';
            //insert agentWorkObj;
            System.runAs(conuser){
            List<GenericConsoleMethodController.tabInfoWrapperClass> lstObj = new List<GenericConsoleMethodController.tabInfoWrapperClass>();
            lstObj.add(wrapObj);
            GenericConsoleMethodController.isRepChatPageAccessible();
            GenericConsoleMethodController.checkChatEnd(liveChatTran.id);
            GenericConsoleMethodController.parseTabInfowrapper(JSON.serialize(lstObj), '123451234512345');
            GenericConsoleMethodController.parseTabInfowrapper(JSON.serialize(lstObj), '123451234512');
            GenericConsoleMethodController.getWorkId(liveChatTran.id);
            //LiveChatTranscript exTran = [Select id from LiveChatTranscript where name='00000001' limit 1];
            //System.debug('exTran'+exTran);
        }
        
     }
    
    
}