/*
 * SFDC -5248  Created By Shravan Godha
 * Description - Terms and Condition document will be attched to Related contact
 * Test Class  - TermsandConditionsTrigger_Test
*/

trigger TermsandConditionsTrigger on Terms_and_Conditions__c (before insert ,after insert,before update,after update,before delete,after delete) {
   
     TriggerRouter.handler(new TermsandConditionsHandler());
   
}