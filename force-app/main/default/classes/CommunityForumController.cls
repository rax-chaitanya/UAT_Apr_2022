/**********************************************************************************

Author: Omkar Narkar
Description: This apex class is created to implement Forum Opt in functionality

**********************************************************************************/
public without sharing class CommunityForumController {
    
    @AuraEnabled
    public static void optInGamification(){
        Group communityForumGroup = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE DeveloperName = 'Rackspace_Partners_Community_Forum' AND Type = 'Regular'];
        Insert new GroupMember(
            GroupId = communityForumGroup.Id,
            UserOrGroupId = UserInfo.getUserId()
        );
        Insert new PermissionSetAssignment(
            PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Partner_Community_Forum_Member'].Id,
            AssigneeId = UserInfo.getUserId()
        );
        
    }
    
    @AuraEnabled
    public static void markAsOptedIn(){
        Id NetworkId = [SELECT Id, Name, Status FROM Network WHERE Name = 'Rackspace Partner Network' AND Status = 'Live' LIMIT 1].Id;
        NetworkMember member =[SELECT Id, NetworkId, MemberId FROM NetworkMember WHERE NetworkId =: NetworkId AND MemberId =: UserInfo.getUserId()];
        List<Gamification_Partner_User_Summary__c> partnerUserSummaryList = [SELECT Id, Name, Gamification_Partner_Summary__c, NetworkMember_Id__c, Reputation_Points__c, Forum_Opted_In__c FROM Gamification_Partner_User_Summary__c WHERE NetworkMember_Id__c =: member.Id];
        Gamification_Partner_User_Summary__c partnerUserSummary;
        if(partnerUserSummaryList.isEmpty()){
            //Below update should create Partner User Summary record
            Update member;
            partnerUserSummary = [SELECT Id, Name, Gamification_Partner_Summary__c, NetworkMember_Id__c, Reputation_Points__c, Forum_Opted_In__c FROM Gamification_Partner_User_Summary__c WHERE NetworkMember_Id__c =: member.Id];
        }else{
            partnerUserSummary = partnerUserSummaryList[0];
        }
        
        partnerUserSummary.Forum_Opted_In__c = true;
        Update partnerUserSummary;
    }
    
}