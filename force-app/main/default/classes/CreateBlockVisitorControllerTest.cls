@isTest
public class CreateBlockVisitorControllerTest {
    @testSetup
    public static  void testSetup()
    {
        TestDataSetUp.insertTestRecords();
    }
    public static testMethod void testCancel()
    {
        CreateBlockVisitorController cntlr = new CreateBlockVisitorController();
        PageReference pg = Page.CreateBlockVisitorPage;
        Test.setCurrentPage(pg);
        cntlr.cancel();
    }
    static testMethod void catchTest(){
    PageReference pg = Page.CreateBlockVisitorPage;
        Test.setCurrentPage(pg);
        Test.startTest();
     CreateBlockVisitorController cntlr = new CreateBlockVisitorController();
        cntlr.developerName=null;
        cntlr.blockVisitorLabel = 'Block test';
        cntlr.description ='this is test class for block chat';
        cntlr.fromIpAddress ='1.1.1.1';
        cntlr.toIpAddress ='2.2.2.2';
        CreateBlockVisitorController cntlr2 = new CreateBlockVisitorController();
        cntlr2.developerName=null;
        cntlr2.blockVisitorLabel = 'Block test';
        cntlr2.description ='this is test class for block chat';
        cntlr2.fromIpAddress ='1.1.1.1';
        cntlr2.toIpAddress ='2.2.2.2';
        try{
            cntlr.save();
            cntlr2.save();
        }catch(Exception e){}
        Test.stopTest();
    }
    static testMethod void CreateBlockVisitorTest(){
        
        PageReference pg = Page.CreateBlockVisitorPage;
        Test.setCurrentPage(pg);
//first run        
        CreateBlockVisitorController cntlr = new CreateBlockVisitorController();
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
       
        cntlr.developerName='Deepak';
        cntlr.blockVisitorLabel = 'Block test';
        cntlr.description ='this is test class for block chat';
        cntlr.fromIpAddress ='1.11.11.2';
        cntlr.toIpAddress ='1.11.12.1';
        cntlr.save();
//second run
        CreateBlockVisitorController cntlr2 = new CreateBlockVisitorController();

        cntlr2.developerName='Deepak';
        cntlr2.blockVisitorLabel = 'Block test';
        cntlr2.description ='this is test class for block chat';
        cntlr2.fromIpAddress ='1.11.11.2';
        cntlr2.toIpAddress =null;
        cntlr2.save();        
//third run
        CreateBlockVisitorController cntlr3 = new CreateBlockVisitorController();
        cntlr3.developerName='';
        cntlr3.blockVisitorLabel = 'block test';
        cntlr3.description ='test desc';
        cntlr3.fromIpAddress ='1.11.11.2';
        cntlr3.toIpAddress =null;
        cntlr3.save();     
        cntlr3.developerName='Deepak';
        cntlr3.blockVisitorLabel = '';
        cntlr3.description ='this is test class for block chat';
        cntlr3.fromIpAddress ='1.11.11.2';
        cntlr3.toIpAddress =null;
        cntlr3.save();        
        cntlr3.blockVisitorLabel = 'Block test';
        cntlr3.developerName='';
        cntlr3.save();                                
        cntlr3.blockVisitorLabel = 'Blocktest';
        cntlr3.developerName='Deepak2';
        cntlr3.fromIpAddress ='';
        cntlr3.toIpAddress ='1.11.12.1';
        cntlr3.save();
        cntlr3.blockVisitorLabel = 'Blocktest';
        cntlr3.developerName='Deepak2';
        cntlr3.fromIpAddress ='1.11.11.2';
        cntlr3.toIpAddress ='1.11.12.1';
        cntlr3.save();
       
        Test.stopTest();
    }
}