/**********************************************************************************

Author: Omkar Narkar/Thirupathi Aeneni
Description: This apex class is created for the Trigger Framework. This class 
has all the working methods to be called by the NetworkMemberHandler.

**********************************************************************************/
public without sharing class NetworkMemberHelper {
    public static boolean After_Update = TRUE;
    public static void syncNetworkMember(){
        try{
            Set<Id> memberIds = new Set<Id>();
            for(NetworkMember member : (List<NetworkMember>)Trigger.new){
                memberIds.add(member.MemberId);
            }
            Map<Id, User> memberUserMap = new Map<Id, User>([SELECT Id, Name, ContactId, Contact.AccountId, Contact.Account.Name FROM User WHERE Id IN: memberIds]);
            
            Map<String, Gamification_Partner_Summary__c> partnerSummaryMap = new Map<String, Gamification_Partner_Summary__c>();
            List<Gamification_Partner_User_Summary__c> partnerUserSummaryList = new List<Gamification_Partner_User_Summary__c>();
            
            Id networkId = Network.getNetworkId();
            
            for(NetworkMember member : (List<NetworkMember>)Trigger.new){
                User memberUser = memberUserMap.get(member.MemberId);
                if(memberUser!=null && memberUser.ContactId!=null && memberUser.Contact.AccountId!=null){
                    if(!partnerSummaryMap.containsKey(memberUser.Contact.AccountId)){
                        partnerSummaryMap.put(memberUser.Contact.AccountId, new Gamification_Partner_Summary__c(
                            Name = memberUser.Contact.Account.Name,
                            Partner_Company__c = memberUser.Contact.AccountId,
                            Partner_Company_Id__c = memberUser.Contact.AccountId,
                            Network_Id__c = member.NetworkId
                        ));
                    }
                }
            }
            Database.Upsert(partnerSummaryMap.values(), Gamification_Partner_Summary__c.fields.Partner_Company_Id__c, true);
            
            Map<Id, NetworkMember> oldMap = (Map<Id, NetworkMember>)Trigger.oldMap;
            for(NetworkMember member : (List<NetworkMember>)Trigger.new){
                User memberUser = memberUserMap.get(member.MemberId);
                if(memberUser!=null && memberUser.ContactId!=null && memberUser.Contact.AccountId!=null){
                    if(partnerSummaryMap.containsKey(memberUser.Contact.AccountId)){
                        Gamification_Partner_User_Summary__c userSummary = new Gamification_Partner_User_Summary__c(
                            Name = memberUser.Name,
                            NetworkMember_Id__c = member.Id,
                            Partner_User__c = member.MemberId,
                            Reputation_Points__c = member.ReputationPoints,
                            Gamification_Partner_Summary__c = partnerSummaryMap.get(memberUser.Contact.AccountId).Id
                        );
                        if(oldMap!=null && member.ReputationPoints > oldMap.get(member.Id).ReputationPoints){
                            userSummary.Latest_Reputation_Points_Earned__c = member.ReputationPoints - oldMap.get(member.Id).ReputationPoints;
                        }
                        populatePointsToNextLevel(userSummary);
                        partnerUserSummaryList.add(userSummary);
                    }
                }
            }
            System.debug('partnerUserSummaryList: '+partnerUserSummaryList);
            Database.Upsert(partnerUserSummaryList, Gamification_Partner_User_Summary__c.fields.NetworkMember_Id__c, true);
        }
        catch(Exception e){}
    }
    
    
    public static void populatePointsToNextLevel(Gamification_Partner_User_Summary__c userSummary){
        
        userSummary.Points_To_Reach_Next_Level__c = 0;
        List<Reputation_Levels__c> reputationLevels = getReputationLevels();
        
        for(Reputation_Levels__c level : reputationLevels){
            if(userSummary.Reputation_Points__c < level.Threshold__c){
                userSummary.Points_To_Reach_Next_Level__c = level.Threshold__c - userSummary.Reputation_Points__c;
                break;
            }
            userSummary.Reputation_Level__c = level.Name;
        }
    }
    
    private static List<Reputation_Levels__c> cachedReputationLevels;
    private static List<Reputation_Levels__c> getReputationLevels(){
        if(cachedReputationLevels != null){
            return cachedReputationLevels;
        }
        cachedReputationLevels = [SELECT Id, Name, Level_Number__c, Threshold__c, Image_URL__c FROM Reputation_Levels__c ORDER BY Level_Number__c];
        return cachedReputationLevels;
    }
    
    //This method is calling from CompanyHandler
    public static void addReputationPointsToPrimaryMember(){
        After_Update = FALSE;
        Map<Id, Account> oldMap = (Map<Id, Account>)Trigger.oldMap;
        Set<Id> ParentIds = new Set<Id>();
        Set<Id> PrimaryMembers = new Set<Id>();
        for (Account company : (List<Account>) Trigger.new){
            If((oldMap == null || (oldMap != null && oldMap.get(company.Id).ParentId != company.ParentId)) && (String.isNotBlank(company.ParentId) && company.Partner_Level__c == Label.PartnerLevel_SubAgent && company.RecordTypeId == Label.Company_Partner_RecordTypeID))
            {
                ParentIds.add(company.ParentId);
            }
            if((oldMap == null || (oldMap != null && oldMap.get(company.Id).Primary_Member__c != company.Primary_Member__c)) && (String.isNotBlank(company.Primary_Member__c) && company.Partner_Level__c == Label.PartnerLevel_SubAgent  && company.RecordTypeId == Label.Company_Partner_RecordTypeID)){
                PrimaryMembers.add(company.Primary_Member__c);
            }
        }
        if(ParentIds.size()>0 || PrimaryMembers.size()>0){
            if(ParentIds.size()>0){
                for(Account parentCompany : [SELECT Id,Primary_Member__c FROM Account WHERE Id IN: ParentIds]){
                    If(String.isNotBlank(parentCompany.Primary_Member__c)){
                        PrimaryMembers.add(parentCompany.Primary_Member__c);
                    }
                }
            }
            if(PrimaryMembers.size()>0){
                List<NetworkMember> updateMembersList= new List<NetworkMember>();
                for(NetworkMember member : [SELECT ID,MemberId,Member.ContactId,ReputationPoints FROM NetworkMember WHERE Member.ContactId IN: PrimaryMembers]){
                    updateMembersList.add(new NetworkMember(Id=member.Id,ReputationPoints=member.ReputationPoints+Gamification_Action_Points__c.getInstance('Create Subagent Company').Points__c));
                }
                if(updateMembersList.size()>0){
                    Update updateMembersList;
                }
            }
        }
    }
    //This method is calling from LeadHandler
    public static void addReputationPointsToPartner(){
        if(System.Label.Partner_Profiles.contains(UserInfo.getProfileId())){
            Set<Id> networkMemberIds = new Set<Id>();
            for (Lead l : (List<Lead>) Trigger.new){
                networkMemberIds.add(l.CreatedById);
            }
            if(networkMemberIds.size()>0){
                List<NetworkMember> networkMembersList = new List<NetworkMember>();
                for(NetworkMember member : [SELECT Id,MemberId,ReputationPoints FROM NetworkMember WHERE MemberId IN : networkMemberIds]){
                    networkMembersList.add(new NetworkMember(Id= member.Id ,ReputationPoints=member.ReputationPoints+Gamification_Action_Points__c.getInstance('Create Partner Lead').Points__c));
                }
                if(networkMembersList.size()>0){
                    update networkMembersList;
                }
            }
        }
    }
    
}