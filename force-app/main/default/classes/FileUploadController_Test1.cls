@isTest 
public class FileUploadController_Test1 
{
    testmethod static void userCreationTest(){ 
    
       Account testAccount = new Account(Name='Test Account61234',BillingCountry='India',ShippingCountry='India');
        
        insert testAccount;

        Account acc=[Select Id,Name From Account where Name='Test Account61234'];
        
      string before = 'Testing base 64 encode';            
      Blob beforeblob = Blob.valueOf(before);
         
         ContentVersion cv = new ContentVersion();
         cv.title = 'test content trigger';      
         cv.PathOnClient ='test';           
         cv.VersionData =beforeblob;          
         insert cv;         
                                                
         ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id LIMIT 1];
  
         List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 1];
 
        
         List<ContentDocument> cd=FileUploadController.getFiles(acc.Id,documents[0].Id);
          FileUploadController.deleteFiles(documents[0].Id);
    


            
           

       
    }
}