@isTest
public class ContentDocumentLinkHandlerTest {
    @testSetup
    static void testSetup() {
        //TestDataHelper.quickSetup();
        //insert TestDataHelper.createTestCompany();
    }

    @isTest
    static void testMethod1() {
        ContentDocumentLinkHandler conHandlerObj = new ContentDocumentLinkHandler();
        conHandlerObj.isActive();
        Trigger_Manager__c obj = new Trigger_Manager__c();
        obj.name = 'ContentDocumentLinkTgr';
        obj.Is_Active__c = true;
        insert obj;
        conHandlerObj.isActive();
        conHandlerObj.beforeInsert();
        conHandlerObj.beforeUpdate();
        conHandlerObj.beforeDelete();
        try{
        conHandlerObj.afterInsert();
        }catch(Exception e){
        System.debug(e);
        }
        conHandlerObj.afterUpdate();
        conHandlerObj.afterDelete();
        conHandlerObj.afterUndelete();
    }
    
}