/*
 * SFDC -5219 and SFDC 5253  Created By Shravan Godha
 * Description Company name and Address details will be update in PartnerFund Claim
 * *
 * Test Class - PartnerFundClaimTrigger_Test
*/

trigger PartnerFundClaimTrigger on PartnerFundClaim (before insert, before update,before delete,after insert, after update,after delete,after Undelete) {
     TriggerRouter.handler(new PartnerFundClaimHandler());
}