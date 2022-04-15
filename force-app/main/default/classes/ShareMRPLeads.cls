public class ShareMRPLeads {

    @InvocableMethod
    public static void shareLeadsToCreators(List<Id> leadIds){

        List<LeadShare> shares = new List<LeadShare>();
        for(Lead l : [Select Id,CreatedById from Lead where Id in : leadIds]){
            shares.add(new LeadShare(LeadId=l.Id,UserOrGroupId = l.CreatedById,LeadAccessLevel='Edit'));
        }     
        insert shares;
    }
}