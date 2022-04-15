trigger PartnerFundRequestTrigger on PartnerFundRequest(before insert,before update) {

    TriggerRouter.handler(new PartnerFundRequestHandler());
         
}