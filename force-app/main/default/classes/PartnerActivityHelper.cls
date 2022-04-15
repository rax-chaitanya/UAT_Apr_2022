public class PartnerActivityHelper{
    public static void mapCommunityContent(){
        Map<String, Community_Content__c> contentMap = new Map<String, Community_Content__c>();
        for(Partner_Activity__c activity : (List< Partner_Activity__c>)Trigger.new){
            if(!contentMap.containsKey(activity.Seismic_ID__c)){
                String contentName = activity.Seismic_Content_Name__c !=null ? activity.Seismic_Content_Name__c : '';
                contentMap.put(activity.Seismic_Content_ID__c, new Community_Content__c(
                    Name = contentName.subString(0, 80>contentName.length() ? contentName.length() : 80), 
                    Seismic_Content_ID__c = activity.Seismic_Content_ID__c, 
                    Seismic_Content_Name__c = contentName));
            }
        }
        Database.Upsert(contentMap.values(), Community_Content__c.fields.Seismic_Content_ID__c, true);
        System.debug('contentMap : '+JSON.serialize(contentMap));
        for(Partner_Activity__c activity : (List< Partner_Activity__c>)Trigger.new){
            if(contentMap.containsKey(activity.Seismic_Content_ID__c)){
                activity.Community_Content__c = contentMap.get(activity.Seismic_Content_ID__c).Id;
            }
        }
    }
    
    public static void awardGamificationPoints(){
        Set<String> memberIds = new Set<String>();
        Id networkId = [SELECT Id FROM Network WHERE Name = 'Rackspace Partner Network' LIMIT 1].Id;
        for(Partner_Activity__c activity : (List< Partner_Activity__c>)Trigger.new){
            memberIds.add(activity.Partner_User__c);
        }
        Map<String, NetworkMember> networkMemberMap = new Map<String, NetworkMember>();
        for(NetworkMember member : [SELECT Id, ReputationPoints, MemberId, Member.Email FROM NetworkMember WHERE MemberId IN: memberIds AND NetworkId =: networkId]){
            networkMemberMap.put(member.MemberId, member);
        }
        
        for(Partner_Activity__c activity : (List< Partner_Activity__c>)Trigger.new){
            System.debug('activity : '+JSON.serialize(activity));
            if(Gamification_Action_Points__c.getAll().containsKey(activity.Action__c) && networkMemberMap.containsKey(activity.Partner_User__c)){
                //Getting the matching network member
                NetworkMember member = networkMemberMap.get(activity.Partner_User__c);
                
                //Awarding the points for action
                member.ReputationPoints += Gamification_Action_Points__c.getInstance(activity.Action__c).Points__c;
                
            }
        }
        Update networkMemberMap.values();
    }
}