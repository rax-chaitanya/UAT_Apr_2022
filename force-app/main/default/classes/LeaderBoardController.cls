/**********************************************************************************

Author: Omkar Narkar/Thirupathi Aeneni
Description: This apex class is created to implement customized Partner Leader board

**********************************************************************************/

public without sharing class LeaderBoardController {
    //Public Static Map<String,Integer> LevelVsPoints{set;get;}
    public static Id networkId = Network.getNetworkId();
    private static Integer partnerCount = 0;
    private static User partnerUser;
        
    @AuraEnabled
    public static Object getUserDetails(){
        Map<String, Object> result = new Map<String, Object>();
        result.put('IsPartner', [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId != null);
        return result;
    }
    
    @AuraEnabled
    public static List<Object> getMemberRanks(){
        
        
        List<Object> result = new List<Object>();
        Set<Id> includedUserIds = new Set<Id>();
        NetworkMember loggedInMember;
        Boolean addedLoggedInUser = false;
        System.debug('networkId'+networkId);
        //Get leaderboard topper
        for(NetworkMember member : [SELECT Id,NetworkId,MemberId,Member.Name,ReputationPoints,Member.contactId FROM NetworkMember WHERE Member.contactId!=null AND NetworkId =:networkId ORDER BY ReputationPoints DESC LIMIT 1]){
            includedUserIds.add(member.MemberId);
            result.add(getMemberDetails(member));
            if(member.MemberId == UserInfo.getUserId()){
                loggedInMember = member;
                addedLoggedInUser = true;
            }
        }
        //Add logged in partner
        if(loggedInMember == null){
            for(NetworkMember member : [SELECT Id,NetworkId,MemberId,Member.Name,ReputationPoints,Member.contactId FROM NetworkMember WHERE Member.contactId!=null AND NetworkId =:networkId AND MemberId =: UserInfo.getUserId() AND (MemberId NOT IN:includedUserIds) LIMIT 1]){
                includedUserIds.add(member.MemberId);
                loggedInMember = member;
            }
        }
        
        //If loggedInMember is not Network Member, then query remaining 9 members of the leaderboard and return the result.
        if(loggedInMember == null){
            for(NetworkMember member : [SELECT Id,NetworkId,MemberId,Member.Name,ReputationPoints,Member.contactId FROM NetworkMember WHERE Member.contactId!=null AND NetworkId =:networkId AND (MemberId NOT IN:includedUserIds) ORDER BY ReputationPoints DESC LIMIT 9]){
                result.add(getMemberDetails(member));
            }
            return result;
        }
        
        //Get 4 partners above logged in partner
        for(NetworkMember member : [SELECT Id,NetworkId,MemberId,Member.Name,ReputationPoints,Member.contactId FROM NetworkMember WHERE Member.contactId!=null AND NetworkId =:networkId AND ReputationPoints > :loggedInMember.ReputationPoints AND (MemberId NOT IN:includedUserIds) ORDER BY ReputationPoints DESC LIMIT 4]){
            includedUserIds.add(member.MemberId);
            result.add(getMemberDetails(member));
        }
        
        if(!addedLoggedInUser){
            result.add(getMemberDetails(loggedInMember));
        }
        
        //Get 4 partners below logged in partner
        for(NetworkMember member : [SELECT Id,NetworkId,MemberId,Member.Name,ReputationPoints,Member.contactId FROM NetworkMember WHERE Member.contactId!=null AND NetworkId =:networkId AND ReputationPoints <= :loggedInMember.ReputationPoints AND (MemberId NOT IN:includedUserIds)  ORDER BY ReputationPoints DESC LIMIT 4]){
            result.add(getMemberDetails(member));
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Object getMemberDetails(NetworkMember member){
        Map<String, Object> memberObject = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(member));
        if(!UserInfo.getUserId().equals(member.MemberId)){
            Map<String, Object> memberRef = (Map<String, Object>)memberObject.get('Member');
            memberRef.put('Name', 'Partner User');
        }
        else{
            memberObject.put('loggedInUser', true);
        }
        
        List<Reputation_Levels__c> reputationLevels = getReputationLevels();
        for(Reputation_Levels__c level : reputationLevels){
            if(member.ReputationPoints >= level.Threshold__c){
                memberObject.put('levelName', level.Name);
                memberObject.put('levelNumber', level.Level_Number__c);
                memberObject.put('levelImageUrl', level.Image_URL__c);
            }
            else{
                break;
            }
        }
        return memberObject;
    }
    
    private static List<Reputation_Levels__c> cachedReputationLevels;
    private static List<Reputation_Levels__c> getReputationLevels(){
        if(cachedReputationLevels != null){
            return cachedReputationLevels;
        }
        cachedReputationLevels = [SELECT Id, Name, Level_Number__c, Threshold__c, Image_URL__c FROM Reputation_Levels__c ORDER BY Level_Number__c];
        return cachedReputationLevels;
    }
    @AuraEnabled
    public static List<Object> getPartnerRanks(){
        
        partnerUser = [SELECT Id, Name, ContactId, Contact.AccountId, Contact.Account.Name FROM User WHERE Id =: UserInfo.getUserId()];
        List<Object> result = new List<Object>();
        Set<Id> includedPartnerIds = new Set<Id>();
        Gamification_Partner_Summary__c loggedInPartner;
        Decimal reputationPointer;
        Boolean addedLoggedInPartner = false;
        
        //Get leaderboard topper
        for(Gamification_Partner_Summary__c partner : [SELECT Id, Name, Reputation_Points__c, Partner_Company__c, Partner_Company_Id__c, Network_Id__c FROM Gamification_Partner_Summary__c WHERE Network_Id__c =:networkId ORDER BY Reputation_Points__c DESC LIMIT 1]){
            includedPartnerIds.add(partner.Partner_Company__c);
            result.add(getPartnerDetails(partner));
            if(partner.Partner_Company__c == partnerUser.Contact.AccountId){
                loggedInPartner = partner;
                addedLoggedInPartner = true;
            }
            reputationPointer = partner.Reputation_Points__c;
        }
        //Add logged in partner
        if(loggedInPartner == null){
            List<Gamification_Partner_Summary__c> loggedInPartnerList = [SELECT Id, Name, Reputation_Points__c, Partner_Company__c, Partner_Company_Id__c, Network_Id__c FROM Gamification_Partner_Summary__c WHERE Network_Id__c =:networkId AND Partner_Company__c =: partnerUser.Contact.AccountId AND (Partner_Company__c NOT IN:includedPartnerIds) LIMIT 1];
            if(!loggedInPartnerList.isEmpty()){
                loggedInPartner = loggedInPartnerList[0];
                includedPartnerIds.add(loggedInPartner.Partner_Company__c);
                reputationPointer = loggedInPartner.Reputation_Points__c;
            }
        }
        //Get 4 partners above logged in partner
        for(Gamification_Partner_Summary__c partner : [SELECT Id, Name, Reputation_Points__c, Partner_Company__c, Partner_Company_Id__c, Network_Id__c FROM Gamification_Partner_Summary__c WHERE Network_Id__c =:networkId AND Reputation_Points__c > :reputationPointer AND (Partner_Company__c NOT IN:includedPartnerIds) ORDER BY Reputation_Points__c DESC LIMIT 4]){
            includedPartnerIds.add(partner.Partner_Company__c);
            result.add(getPartnerDetails(partner));
        }
        
        if(loggedInPartner!=null && !addedLoggedInPartner){
            result.add(getPartnerDetails(loggedInPartner));
        }
        
        //Get 4 partners below logged in partner
        for(Gamification_Partner_Summary__c partner : [SELECT Id, Name, Reputation_Points__c, Partner_Company__c, Partner_Company_Id__c, Network_Id__c FROM Gamification_Partner_Summary__c WHERE Network_Id__c =:networkId AND Reputation_Points__c <= :reputationPointer AND (Partner_Company__c NOT IN:includedPartnerIds) ORDER BY Reputation_Points__c DESC LIMIT 4]){
            result.add(getPartnerDetails(partner));
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Object getPartnerDetails(Gamification_Partner_Summary__c partner){
        Map<String, Object> partnerObject = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(partner));
        if(partner.Partner_Company__c != partnerUser.Contact.AccountId){
            partnerObject.put('Name', 'Partner Company');
        }
        else{
            partnerObject.put('loggedInPartner', true);
        }
        return partnerObject;
    }
    
    @AuraEnabled
    public static void updateLevelIcons(){
        List<ReputationLevel> reputationLevels = [SELECT Id, ParentId, Label, Threshold, LevelNumber FROM ReputationLevel WHERE ParentId =: networkId];
        NetworkMember member = Test.isRunningTest() ? [SELECT Id, NetworkId, MemberId, ReputationPoints FROM NetworkMember WHERE NetworkId =: networkId LIMIT 1]
        : [SELECT Id, NetworkId, MemberId, ReputationPoints FROM NetworkMember WHERE NetworkId =: networkId AND MemberId =: UserInfo.getUserId()];
        Double reputationPoints = member.ReputationPoints;
        
        Delete [SELECT Id FROM Reputation_Levels__c];
        
        List<Reputation_Levels__c> updatedReputationLevelSettings = new List<Reputation_Levels__c>();
        NetworkMemberHandler.IS_TRIGGER_ENABLED = false;
        Integer dummyLevelNumber = 1;
        for(ReputationLevel level : reputationLevels){
            member.ReputationPoints = level.Threshold;
            Update member;
            ConnectApi.Reputation reputation = ConnectApi.ChatterUsers.getReputation(networkId, member.MemberId);
            updatedReputationLevelSettings.add(new Reputation_Levels__c(
                Name = level.Label==null ? 'Level Name'+ dummyLevelNumber : level.Label,
                Level_Number__c = level.LevelNumber,
                Image_URL__c = reputation.reputationLevel.levelImageUrl,
                Threshold__c = level.Threshold
            ));
            dummyLevelNumber++;
        }
        Insert updatedReputationLevelSettings;
        
        member.ReputationPoints = reputationPoints;
        Update member;
        NetworkMemberHandler.IS_TRIGGER_ENABLED = false;
    }
}