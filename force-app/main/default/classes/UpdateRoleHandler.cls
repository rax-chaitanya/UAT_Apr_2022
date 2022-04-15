public class UpdateRoleHandler 
{
  public static void updateRole()
    {
        try {
            
            Set<Id> accIds = new Set<Id>();
            for(AccountContactRelation acr : (List<AccountContactRelation>)Trigger.new)
            {
                if(acr.Roles== 'Primary Contact')
                {
                    accIds.add(acr.AccountId);
                }   
            }
            
            List<AccountContactRelation> ACRListToUpdate = new List<AccountContactRelation>();
            for(AccountContactRelation acr : [select Id, Roles from AccountContactRelation  where AccountId IN : accIds and Roles= 'Primary Contact'])
            {
                acr.Roles= 'Technical';
                ACRListToUpdate.add(acr);
            }
            
            update ACRListToUpdate;
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, true);
        }
    }
}