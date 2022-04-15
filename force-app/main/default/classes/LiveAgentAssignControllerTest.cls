@isTest
public class LiveAgentAssignControllerTest {
     @testSetup  
    public static  void testSetup(){
        TestDataSetUp.insertTestRecords();
    }
    
    public static testMethod void  myAssignTest()
    {
         LiveAgentAssignController lAssign=new LiveAgentAssignController();
         PageReference myPageRef= Page.LiveAgentAssignPage; 
         Test.setCurrentPage(myPageRef);
         List<LiveChatUserConfig> myUserConfig=new List<LiveChatUserConfig>();
         myUserConfig=[select Id,DeveloperName from LiveChatUserConfig];
         lAssign.configUsers=myUserConfig;
         LiveChatUserConfig lc=new LiveChatUserConfig();
         lc=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
         lAssign.config=lc.Id;
         lAssign.whereClause='';
         lAssign.filterAvailableUsers();
         lAssign.whereClause='hello';
         lAssign.filterAvailableUsers();
         Profile myProfile=new Profile();
         myProfile= [select Id,Name from Profile where Name=:'Standard User'];
        User myUser=new User(FirstName='testUser',LastName='testLName',Email='tt@gmail.com',Alias='ttcom',
                             ProfileId=myProfile.Id,LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US',EmailEncodingKey='UTF-8',
                             TimeZoneSidKey='America/Los_Angeles', UserName='Quetesting@testorg.com');
        insert myUser;
        lAssign.UpdateList();
        lAssign.getAvailableUsers();
        lAssign.getSelectedUsers();
        lAssign.selectedUserIds.add(myUser.id);
        lAssign.addUser();
        lAssign.removedUserIds.add(myUser.id);
        lAssign.removeUser();
        LivechatUserConfig lcs= new LivechatUserConfig();
        lcs=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
        lAssign.config=lcs.Id;
        lAssign.cancel();
        lAssign.config='';
        lAssign.cancel();
    }
    public static testMethod void soapSave()
    {
        LiveAgentAssignController myAgent=new LiveAgentAssignController();
        PageReference myPageRef= Page.LiveAgentAssignPage; 
        Test.setCurrentPage(myPageRef);
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
        List<LiveChatUserConfig> myUserConfig=new List<LiveChatUserConfig>();
        myUserConfig=[select Id,DeveloperName from LiveChatUserConfig];
        myAgent.configUsers=myUserConfig;
        LiveChatUserConfig lc=new LiveChatUserConfig();
        lc=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
        myAgent.config=lc.Id;
        myAgent.whereClause='';
        myAgent.filterAvailableUsers();
        myAgent.whereClause='hello';
        myAgent.filterAvailableUsers();
        myAgent.save();
        User myLc=new User();
        myAgent.getAvailableUsers(); 
        myAgent.selectedUserIds.add(myLc.Id); 
        myAgent.addUser();
        myAgent.getAvailableUsers(); 
        myAgent.selectedUserIds.add(myLc.Id); 
        LiveChatUserConfig lCUC=new LiveChatUserConfig();
        lCUC=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
        myAgent.config=lCUC.Id;
        myAgent.removedUserIds.add(myLc.Id);
        myAgent.removeUser();
        myAgent.getSelectedUsers();
        myAgent.addUser();
        myAgent.getAvailableUsers();
        myAgent.selectedUserIds.add(myLc.Id);
        myAgent.removedUserIds.add(myLc.Id);
        myAgent.removeUser();
        myAgent.getSelectedUsers();
        myAgent.userAdded=True;
        myAgent.userRemoved=False;
        myAgent.addUser();
        myAgent.getAvailableUsers();
        User myUser=[select Id,LastName,UserName,Alias from User LIMIT 1];
        myAgent.selectedUserIds.add(myUser.Id);
        myAgent.removedUserIds.add(myUser.Id);
        myAgent.save();
        myAgent.removeUser();
        myAgent.getSelectedUsers();
        myAgent.userRemoved=True;
        myAgent.userAdded=True;
        myAgent.save();
        Test.stopTest();

       } 
   }