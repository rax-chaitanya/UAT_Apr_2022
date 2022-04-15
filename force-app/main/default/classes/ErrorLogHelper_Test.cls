@istest
public class ErrorLogHelper_Test {
    private static testmethod void testlogErrorRecord(){
        ErrorLogHelper.logErrorRecord('Try Again','Insert');
        
    }
    private static testmethod void testlogErrorRecord1(){
        List<Contact> listToUpdate=new List<Contact>();
        
        Contact con=new Contact(firstname='Test',lastname='INVALIDNAME');
       listToUpdate.add(con);
        List<Database.SaveResult> srList =new List<Database.SaveResult>();
           srList.add(Database.insert(con, false));
        
        Contact con1=new Contact(firstname='Test',lastname='Valuea');
       listToUpdate.add(con1);
        srList .add( Database.insert(con1, false));
       Contact con2=new Contact(firstname='Test1',lastname='Invalid');
       
       srList .add( Database.insert(con2, false));
        listToUpdate.add(con2);
        ErrorLogHelper.logErrorRecords(srList, listToUpdate, 'insert');
    }
    
}