/*
Class Name- ContactHelper
Created Date-05 July 2018
Created By -Biswa
*/
public class ContactHelper {
    /****************SFDC-2155 starts added by Biswa******************/
    
    public static void activeInactiveUsers(set<id> contactIds){
        List<User> users = [Select Id,isActive,Contact.Inactive__c from User where ContactId in : contactIds];
        if(users != null &&  !users.isEmpty()){
            for(User u : users)
                u.IsActive = u.Contact.Inactive__c ? false : true;
            System.enqueueJob(new CommunityShareQueue(Users));
        }
    }
    public static void createPartnerUser(List<Contact> ContactfromPartnerportal){
        Set<Id> contactIds = new Set<Id>();
        List<User> partnerUsers = new List<User>(); 
        Map<Id,User> users = new Map<Id,User>();
        for(Contact con : ContactfromPartnerportal){
            contactIds.add(con.id);
        }
        Map<Id,Contact> contactsMap = new Map<Id,Contact>([SELECT ID,Name,Email,account.Partner_License_Type__c ,FirstName,LastName,Title,AccountId,Account.Name FROM Contact where id in : contactIds]);
        for(User us : [Select Id,ContactId from User where contactId in : contactIds]){
            users.put(us.ContactId, us);  
        }
        Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];
            for(Contact co : ContactfromPartnerportal){
            Contact c = contactsMap.get(co.id);
            if(users != null && !users.containsKey(c.Id)){
                if(org.IsSandbox){
                    if(c.account.Partner_License_Type__c == 'Partner Community Login'){
                        partnerUsers.add(new User(userName=c.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile,
                                                  Alias=(c.Name.length()>8)?c.Name.substring(0,7).deleteWhitespace().toLowerCase():c.Name.deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                    }
                    else{
                        partnerUsers.add(new User(userName=c.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Profile,
                                                  Alias=(c.Name.length()>8)?c.Name.substring(0,7).deleteWhitespace().toLowerCase():c.Name.deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                    }
                    } else{
                    
                    if(c.account.Partner_License_Type__c == 'Partner Community Login')
                        partnerUsers.add(new User(userName=c.Email+'.rax.partner',Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile,
                                                  Alias=(c.Name.length()>8)?c.Name.substring(0,7).deleteWhitespace().toLowerCase():c.Name.deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                    
                    else
                        partnerUsers.add(new User(userName=c.Email+'.rax.partner',Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Profile ,
                                                  Alias=(c.Name.length()>8)?c.Name.substring(0,7).deleteWhitespace().toLowerCase():c.Name.deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                }   
            }  
        }
        if(!partnerUsers.isEmpty())
            System.enqueueJob(new PortalUserCreation(partnerUsers));
    }    
    Public Static void validateContactEdit(){
        
        User user = [Select Id,Accountid,ContactId,Account.Primary_Member__c,Contact.inactive__c from User where id =:UserInfo.getUserId()];
        for (Contact co : (List<Contact>) Trigger.new){
            if(co.RecordTypeId != Label.Partner_Record_Type)
                co.addError(Label.Contact_Record_Type_Error);
            if(user.ContactId != user.Account.Primary_Member__c)
                co.addError(Label.Partner_Primary_Member_Creation_Error);
            if(user.ContactId == user.Account.Primary_Member__c &&  co.AccountId != user.AccountId)
                co.addError(Label.Partner_other_that_primary_member_edit_error);
            if(co.Id == user.ContactId && co.inactive__c == true)
                co.addError(Label.Primary_Member_self_deactivation_error);
        }
        
    }
    
    /********************SFDC-2155 End - Biswa *********************/
    
     //Gtmo-397, To fix contact filter validation on Lead convert, Start
    Public Static void updateCmp(){
      System.debug('Update Cmp ');
        set<id> accids = new set<id>();
        
        for(Contact con : (List<Contact>) Trigger.new){
            if(con.accountid!= null){
                accids.add(con.accountid);
            }
        }
        map<id,account> Cmpmap = new map<id,account>([Select id,name,Company_Name__c,Recordtypeid from Account where id =: accids]);
        System.debug('Cmpmap .......'+Cmpmap );
        for(Contact con : (List<Contact>) Trigger.new){
            if(Cmpmap.containskey(con.accountid) && System.Label.AccountRecordTypes.contains(Cmpmap.get(con.accountid).Recordtypeid)){
                con.accountid= Cmpmap.get(con.accountid).Company_Name__c;
               
                
                
            }
        }
}
//Gtmo-397, To fix contact filter validation on Lead convert, End
    //Added by sundarayya E for SFDC-5307
    public static void updateBtlkAddFields(List<Contact> triggerNewList){
         Map<String,string> countryvalues = new Map<String, String>();
        Map<String,string> statevalues = new Map<String, String>();
         Map<String, String> btlkcustStateValue = new Map<String, String>();
        Schema.DescribeFieldResult countryfieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> countryPicValues = countryfieldResult.getPicklistValues();
        Map<String, BrightTALK__BrightTalk_State_Codes__c> BtlkcustomStateCodes = BrightTALK__BrightTalk_State_Codes__c.getall();

   		for(String key : BtlkcustomStateCodes.keySet()){
              //  StateValues.add(bucketRolesMap.get(key).BrightTALK__State_Alpha_2__c);
        //system.debug('State==  '+key+'  @@StateCodes'+bucketRolesMap.get(key).BrightTALK__State_Alpha_2__c);
       	 btlkcustStateValue.put(key, BtlkcustomStateCodes.get(key).BrightTALK__State_Alpha_2__c);
            }
        Schema.DescribeFieldResult statefieldResult = User.statecode.getDescribe();
        List<Schema.PicklistEntry> statePicValues = statefieldResult.getPicklistValues();
        for( Schema.PicklistEntry statePickVal : statePicValues){
            //System.debug(statePickVal.getLabel() +'::'+ statePickVal.getValue());
            statevalues.put(statePickVal.getLabel(), statePickVal.getValue());
            }
	    for( Schema.PicklistEntry f : countryPicValues){
            //System.debug(f.getLabel() +'::'+ f.getValue());
            countryvalues.put(f.getLabel(), f.getValue());
		}
        for(Contact Con : triggerNewList){
            if(countryvalues.containsKey(Con.Btlk_Country__c)){
                Con.MailingCountryCode = countryvalues.get(Con.Btlk_Country__c);
             if(btlkcustStateValue.containsKey(con.Btlk_Sate_Province__c)){
                    con.MailingStateCode = btlkcustStateValue.get(con.Btlk_Sate_Province__c);
                }else if(statevalues.containsKey(Con.Btlk_Sate_Province__c)){
                Con.MailingStateCode = statevalues.get(Con.Btlk_Sate_Province__c);
            }
            }
        }
    }
    //Added by sundarayya E for SFDC-5307--Ends
    //
        //Added by Chaitanya for SFDC-6105
    public static void updateEmployeeManagers(Map<string,string> CurrentEmptoManager,List<Contact> triggerNewList){
        Map<string,string> AllManagerMap= new Map<string,string>();
        Set<string> man_of_man1 =new set<string>();
        Set<string> man_of_man2 =new set<string>();
        for(Contact conman1 :[Select id,name,Employee_Number__c,Manager__c,Manager_Employee_Number__c from contact where Employee_Number__c in :CurrentEmptoManager.values()])
        {

            if(conman1.Manager_Employee_Number__c!=null){
                man_of_man1.add(conman1.Manager_Employee_Number__c);
            }
            AllManagerMap.put(conman1.name,conman1.Manager__c);            
        }     
        if(!man_of_man1.isempty()){
            for(Contact conman2 :[Select id,name,Employee_Number__c,Manager__c,Manager_Employee_Number__c from contact where Employee_Number__c in :man_of_man1])
            {
                if(conman2.Manager_Employee_Number__c!=null){
                    man_of_man2.add(conman2.Manager_Employee_Number__c);                   
                }
                AllManagerMap.put(conman2.name,conman2.Manager__c);                
            }    
        }
      /*  if(!man_of_man2.isempty()){
            for(Contact conman3 :[Select id,name,Employee_Number__c,Manager__c,Manager_Employee_Number__c from contact where  Employee_Number__c in :man_of_man2])
            {
                AllManagerMap.put(conman3.name,conman3.Manager__c);                
            }
        }*/
        for(Contact Con : triggerNewList){
            if(CurrentEmptoManager.containsKey(Con.Employee_Number__c) ){
                
                if(AllManagerMap.containskey(Con.manager__c) && con.Manager__c!=AllManagerMap.get(Con.manager__c)){
                    Con.Manager_Level2__c = AllManagerMap.get(Con.manager__c);                  
                }
                if(AllManagerMap.containskey(Con.Manager_Level2__c) && con.Manager_Level2__c!=AllManagerMap.get(Con.Manager_Level2__c)){
                    Con.Manager_Level3__c = AllManagerMap.get(Con.Manager_Level2__c);                  
                }
                
              /*  if(AllManagerMap.containskey(Con.Manager2__c) && con.Manager2__c!=AllManagerMap.get(Con.Manager2__c)){
                    Con.Manager3__c = AllManagerMap.get(Con.Manager2__c);               
                }  */
                
            }            
        }
    } 
    //End of SFDC-6105 story
}