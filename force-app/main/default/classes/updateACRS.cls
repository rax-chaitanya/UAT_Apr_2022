public class updateACRS {
 @AuraEnabled
  public static List<Account_Contact_Role__c> getACRs(String ParentId) {
  	  List<Account_Contact_Role__c> totalList = new List<Account_Contact_Role__c>();
      	for(Account_Contact_Role__c cc : [SELECT id,Account__r.Name,Phone__c,Role__c,Email__c from Account_Contact_Role__c where Contact__c=:ParentId]){
          totalList.add(cc);
      	}	
      return totalList;
  }
    
  @AuraEnabled
  public static void updateSelectedACRs(ID ParentId , List<String> lstOfContactIds){
    try{
        list<Account_Contact_Role__c> lstContacts = new list<Account_Contact_Role__c>();
      	Contact con=new Contact();
      		
         con=[Select Id,MailingCountry,MailingState,MailingStreet,MailingCity,MailingPostalCode from Contact where ID=:ParentId];
        
      for(Account_Contact_Role__c ac :[Select id,Mailing_Country__c ,Mailing_State__c,Mailing_Street__c,Mailing_City__c,Mailing_Postal_Code__c from Account_Contact_Role__c where ID IN:lstOfContactIds])
      {
        
          ac.Mailing_Country__c=con.MailingCountry;
       
          ac.Mailing_State__c=con.MailingState;
       
          ac.Mailing_Street__c=con.MailingStreet;
      
          ac.Mailing_City__c=con.MailingCity;
       
          ac.Mailing_Postal_Code__c=con.MailingPostalCode;
        
        lstContacts.add(ac);
    }
        update lstContacts;
    }
      catch (Exception e) {
             ExceptionHandler.postToAll(e, true);
         }
      
 }
}