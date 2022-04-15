trigger CompanyCampaign on Company_Campaign__c (before insert,after insert,before update,after update,before delete,
                                                after delete,after undelete) {
   TriggerRouter.handler(new CompanyCampaignHandler());
      

}