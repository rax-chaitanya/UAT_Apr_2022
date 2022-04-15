trigger QlikViewAfterTrigger on Movers_Shakers_Account__c (after insert) {

List <Movers_Shakers_Details__c> TaskToInsert= new List<Movers_Shakers_Details__c>();
List <Movers_Shakers_Details__c> TaskToUpdate= new List<Movers_Shakers_Details__c>();
//List <Movers_Shakers_Detail_Line_Item__c> TaskDetailtoCreate = new List<Movers_Shakers_Detail_Line_Item__c>();

// 1. Look for Accounts based on DDIs

List<String> LDDI = new List <String>();
List<String> AMNames = new List <String>();
List<String> CountryNames = new List <String>();
List<String> LNames=new List<String>();
List<String> LEmails=new List<String>();
List<String> LPhones=new List<String>();

for (Movers_Shakers_Account__c qv: trigger.new) {
     LDDI.add(qv.DDI__c);
     AMNames.add(qv.Account_Manager__c);
     CountryNames.add(qv.Country__c);
     LNames.add(qv.Primary_Contact_Name__c);
     LEmails.add(qv.Primary_contact_email__c);
     LPhones.add(qv.Primary_contact_Phone__c);
}
system.debug('LDDI ' + LDDI);
// Map -  Existing QlikAccounts
List<Movers_Shakers_Details__c > ExistQA = new List<Movers_Shakers_Details__c> ([Select Id,DDI__c, Last_Invoice_MRR__c,final_mrr__c, Current_Server_Units__c,Final_Server_Units__c from Movers_Shakers_Details__c where DDI__c in :LDDI]);
List<User> LAccountMgrs= [Select Id,Name from User where Isactive=true and Name in :AMNames order by Name];
//raj - List<Country__c> LCountry= [Select Id,Name from Country__c where  Name in :CountryNames order by Name];
List<Id> AccIds = CMPorACCRecordType_Utility.query_Utility(Label.AccountRecordTypes);
List<Account> ListAccount = new List<Account>([Select Id,DDI__c,Name,Status__c,Industry,Ownerid,Support_Team__c from Account where DDI__c in :LDDI AND RecordTypeId IN : AccIds]);

for (Movers_Shakers_Account__c qv: trigger.new) {
     if (qv.DDI__c=='999999999') continue;
     Movers_Shakers_Details__c t1 = new Movers_Shakers_Details__c();
     
     for (Account acc:ListAccount) {
       if (qv.DDI__c==acc.DDI__c)
        t1.Account__c=acc.Id;
     }
     
     for (User us:LAccountMgrs) {
        if (qv.Account_Manager__C==us.Name)
         t1.Account_Manager__c=us.Id;
     } 
     
     /*Raj
     for (Country__c coun:LCountry) {
        if (qv.Country__c==coun.Name)
         t1.Country__c=coun.Id;
     }
     raj */ 
     
     Integer Times=0; 
     Id ExistQAId;
     
     t1.Country2__c=qv.Country__c; //raj
     t1.Status__c=qv.Status__c;
     t1.Last_Invoice__c=qv.Last_Invoice__c;
     
     if (times==0) {
       t1.Last_Invoice_MRR__c=qv.MRR__c;
       t1.Current_Server_Units__c =qv.Server_Units__c;
     } else {
       t1.Final_MRR__c=qv.MRR__c;
       t1.Final_Server_Units__c=qv.Server_Units__c;
     }    
     
     t1.MRR__c=qv.MRR__c;
     
     t1.Support_Team__c=qv.Team__c;
     t1.Movers_Shakers_Integration__c =qv.Id;
     t1.DDI__c=qv.DDI__c;
     t1.Last_Invoice__c=qv.Last_Invoice__c;
     t1.Status__c=qv.Status__c;
     t1.Support_Team__c=qv.Team__c;
     t1.Primary_Contact_Name__c=qv.Primary_Contact_Name__c;
     t1.Primary_Contact_Email__c=qv.Primary_Contact_Email__c;
     t1.Primary_Contact_Phone__c=qv.Primary_Contact_Phone__c;
     
     // case 58204 NEW FIELDS TO MAP: Trend
     
     t1.trend__c=qv.Delta_From_file__c;
     t1.Current_Server_Units__c=qv.Server_Units__c;
     
     TaskToInsert.add(t1);
     }
   insert TasktoInsert;
}