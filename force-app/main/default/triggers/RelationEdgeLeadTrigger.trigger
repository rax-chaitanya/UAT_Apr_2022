/**********************************************************************************
Author: Raj
Description: Trigger on RelationEdge_Lead__c which will call the RelationEdgeLeadHandler on all events.
Modification History : 
**********************************************************************************/

trigger RelationEdgeLeadTrigger on RelationEdge_Lead__c(before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new RelationEdgeLeadHandler());     
}