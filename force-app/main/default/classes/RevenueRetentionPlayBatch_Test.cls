@isTest
public class RevenueRetentionPlayBatch_Test {
    public static testMethod void testRunAs(){       
		Test.startTest();        
        String filter='bBVINES';
        RevenueRetentionPlayBatch BC=new RevenueRetentionPlayBatch();
        Account a=new Account(name='bBVINES');
        insert a;
        DataBase.executeBatch(BC,200);
        Test.stopTest();             
    }
}