/********************************************************************************************************
* @developer   : Diego Castro
* @date        : 06/05/17
* @description : Tests the UTIL_ChildUpdater class. 
*********************************************************************************************************/
@isTest
public class UTIL_ChildUpdater_Test {
        
    /********************************************************************************************************
    * @developer   : Diego Castro
    * @date        : 06/05/17
    * @description : Sets up custom setting, contact, and task dummy data. 
    *********************************************************************************************************/    
        
    @testSetup
    static void testSetup() {
        SObject[] toInsert = new List<SObject>();
        Set<String> triggerNames = new Set<String>();
        
        TestClassUtility.setTestSetupData();
        insert toInsert;

        Contact[] contacts = new List<Contact>();
		        
        for (integer i = 1; i <= 100; ++i) {
            Contact c = new Contact(FirstName = 'Dummy ' + i , LastName = 'Dummy ' + i);
            c.Old_Record_Id__c = String.valueOf(i);
            contacts.add(c);
        }
        
        insert contacts;
        
        Task[] tasks = new list<Task>();
        for (Contact c : contacts) {
            for (Integer i = 1; i <= 10; ++i) {
                Task t = new Task(Subject = 'Task ' + i, WhoId = c.Id);
                tasks.add(t);
            }
        }
        insert tasks;
    }
    
    @isTest
    static void test_getQuery() {
        Child_Query_Settings__c setting = new Child_Query_Settings__c(Name = 'Account', Include__c = 'Opportunities');
        String expected = 'SELECT ID, ' + '( SELECT ID from ' + setting.Include__c + ' WHERE ' + Label.Linkage_Field + '= null )' + ' FROM ' + setting.Name ;
        String actual = UTIL_ChildUpdater.getQuery(setting);
        
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void test_grabChildRecords() {
        Child_Query_Settings__C setting = new Child_Query_Settings__c(Name = 'Contact', Include__C = 'Tasks');
        
        sObject[] sObjects =  Database.query ( UTIL_ChildUpdater.getQuery(setting) ) ;
        
        sObject[] childRecords = UTIL_ChildUpdater.grabChildRecords(sObjects, setting);
        
        System.assertEquals(1000, childRecords.size());
    }
}