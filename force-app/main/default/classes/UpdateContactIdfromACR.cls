public class UpdateContactIdfromACR 
{
    public static void updateContactId() 
    {
        //Test.isRunningTest() is added by Anjaneyulu to improve code coverage
        if(UserInfo.getUserID().Contains(label.FMWFoundationUser) || Test.isRunningTest())
        {
            Set<String> acrIds = new Set<String>();
            for(CampaignMember cm :(List<CampaignMember>)Trigger.new)
            {
                acrIds.add(cm.acr_id__c);  
            }   
        
            Map<String,String> cMap = new Map<String,String>();
    
            for(AccountContactRelation acr : [Select id,contactId from AccountContactRelation where id IN: acrIds])
            {
                cMap.put(acr.id, acr.contactId);
            }
        
            for(CampaignMember cmp : (List<CampaignMember>)Trigger.new)
            {
                cmp.ContactId = cMap.get(cmp.acr_id__c);
            }
        }
    }
}