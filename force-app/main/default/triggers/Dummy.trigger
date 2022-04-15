trigger Dummy on Account_Contact_Role__c (before insert,before update) {

for(Account_Contact_Role__c acr:Trigger.New)
{
 acr.Account_Contact_Ids__c = acr.get('Account__c')+'_'+acr.get('Contact__c');
}

}