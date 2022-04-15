@isTest
Public class Company_RequestAccessController_test{
static TestMethod Void Company_RequestAcc(){
TestClassUtility.setTestSetupData();  
try{
//contact con =new Contact();
 Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;
        Company_RequestAccessController.getUserRecordAccess(c.id);
        Company_RequestAccessController.getProcessInstance(c.id);
       }catch(Exception e){       

}
}
}