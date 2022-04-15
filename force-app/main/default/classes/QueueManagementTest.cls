@isTest
public class QueueManagementTest{
    public static testMethod void CreateTest(){
        Profile pr = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User us = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                       EmailEncodingKey='UTF-8', LastName='Quetesting', LanguageLocaleKey='en_US', 
                       LocaleSidKey='en_US', ProfileId = pr.Id, 
                       TimeZoneSidKey='America/Los_Angeles', UserName='Quetesting1@testorg.com');
        insert us;
        system.runas(us){
        PageReference pg = Page.QueueCreatePage;
        Test.setCurrentPage(pg);
        QueueCreateController cntlr = new QueueCreateController();
        cntlr.SupportedObjects();
        cntlr.selectUsr=new List<GroupMember>();
        cntlr.developerName = '';
        cntlr.usrtoadd = new List<GroupMember>();
        cntlr.QueName = 'Queue Test';
        cntlr.QueEmail = 'testqueuetestemail@testorg.com';
        cntlr.sendEmailToMembers = false;
        cntlr.selectedSObjects.add(cntlr.avaliableSupportedObjectsMap.get('Lead'));
        cntlr.addSupportedObjects();
        cntlr.selectedSObjects.add('Order');
        cntlr.addSupportedObjects();
        cntlr.removeSObjects.add('Order');
        cntlr.removeSupportedObjects();
        cntlr.selectedUsr.add(us.id);
        cntlr.addUsers();
        cntlr.removeUsers.add(us.id);
        cntlr.removeUsers();
        cntlr.save();
        
        
        PageReference pg2 = Page.QueueCreatePage;
        Test.setCurrentPage(pg2);
        QueueCreateController cntlr2 = new QueueCreateController();
        cntlr2.SupportedObjects();
        cntlr2.QueName = 'Queue Test';
        cntlr2.QueEmail = 'testqueuetestemail@testorg.com';
        cntlr2.sendEmailToMembers = false;
        cntlr2.cancel();
        cntlr2.QueName = 'Queue Test2';
        cntlr2.QueEmail = 'testqueuetestemail@testorg.com';
        cntlr2.sendEmailToMembers = false;
        cntlr2.selectedSObjects.add('LiveChatTranscript');
        cntlr2.addSupportedObjects();
        cntlr2.getSelectedSupportedObjects();
        cntlr2.getAvailableSupportedObjects();
        system.debug('###########################'+cntlr2.selectedSupportedObjectsMap.keyset() );
        cntlr2.selectedUsr.add(us.id);       
        cntlr2.addUsers();
        
        //cntlr2.selectedUsersMap = new Map<id, String>();
        //cntlr2.selectedUsersMap.put(us.Id,us.Name);
        cntlr2.getAvailableUsers();
        
        
        //cntlr2.getSelectedUsersList();
        cntlr2.save();
        
        PageReference pg3 = Page.QueueCreatePage;
        Test.setCurrentPage(pg3);
        QueueCreateController cntlr3 = new QueueCreateController();
        cntlr3.save();
        
        PageReference pg4 = Page.QueueCreatePage;
        Test.setCurrentPage(pg4);
        QueueCreateController cntlr4 = new QueueCreateController();
        cntlr4.QueName = 'Queue Test2';
        cntlr4.save();

     }
    }
    public static testMethod void EditTest(){
    Profile pr = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User us = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                       EmailEncodingKey='UTF-8', LastName='Quetesting', LanguageLocaleKey='en_US', 
                       LocaleSidKey='en_US', ProfileId = pr.Id, 
                       TimeZoneSidKey='America/Los_Angeles', UserName='Quetesting1@testorg.com');
        insert us;
        
        PageReference pg = Page.QueueEditPage;
        Test.setCurrentPage(pg);
        QueueEditController ecntlr = new QueueEditController();
        ecntlr.SupportedObjects();
        ecntlr.SearchQue1='';
        ecntlr.SearchQueList1();
        ecntlr.SearchQue1='nonexistantname';
        ecntlr.SearchQueList1();
        Group g = new Group(Type='Queue', Name='TestQueue',Email='testqueueemail@rackspacetest.com',DoesSendEmailToMembers=false);
        insert g;
        ecntlr.SearchQue1='test';
        ecntlr.SearchQueList1();
        ApexPages.currentPage().getParameters().put('EditId',g.Id);
        ApexPages.currentPage().getParameters().put('EditName',g.Name);
        ApexPages.currentPage().getParameters().put('EditEmail',g.Email);
        ApexPages.currentPage().getParameters().put('EditMemTo',String.valueof(g.DoesSendEmailToMembers));
        
        ecntlr.EditQue();
        ecntlr.selectedSObjects.add('Lead');
        ecntlr.addSupportedObjects();
        ecntlr.getAvailableSupportedObjects();
        ecntlr.getSelectedSupportedObjects();
        ecntlr.selectedSObjects.add('Order');
        ecntlr.addSupportedObjects();
        ecntlr.removeSObjects.add('Order');
        ecntlr.removeSupportedObjects();
        ecntlr.selectedUsr.add(us.id);
        ecntlr.addUsers();
        ecntlr.getAvailableUsers();
        //ecntlr.getSelectedUsersList();
        
        ecntlr.save();
        ecntlr.SearchQue1='test';
        ecntlr.SearchQueList1();
        ApexPages.currentPage().getParameters().put('EditId',g.Id);
        ApexPages.currentPage().getParameters().put('EditName',g.Name);
        ApexPages.currentPage().getParameters().put('EditEmail',g.Email);
        ApexPages.currentPage().getParameters().put('EditMemTo',String.valueof(g.DoesSendEmailToMembers));
        
        ecntlr.EditQue();
        ecntlr.selectedSObjects.add('LiveChatTranscript');
        ecntlr.addSupportedObjects();
        ecntlr.cancel();
        ApexPages.currentPage().getParameters().put('DelId',g.Id);
        ecntlr.DeleteQue();
        ApexPages.currentPage().getParameters().put('EditId',g.Id);
        ApexPages.currentPage().getParameters().put('EditName',g.Name);
        ApexPages.currentPage().getParameters().put('EditEmail',g.Email);
        ApexPages.currentPage().getParameters().put('EditMemTo',String.valueof(g.DoesSendEmailToMembers));
        
        ecntlr.EditQue();
        ecntlr.removeUsers.add(us.id);
        ecntlr.removeUsers();
        ecntlr.save();
        ApexPages.currentPage().getParameters().put('DelId',g.Id);
        ecntlr.DeleteQue();
        }
}