public class PartnerFundRequestTriggerHelper {

    public static void beforeInsertOperations(List<PartnerFundRequest> fundRequests){
        
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> campaignIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
    for(PartnerFundRequest fundRec: fundRequests){
        
        if(fundRec.ChannelPartnerId !=null ){
            accIdSet.add(fundRec.ChannelPartnerId);
        }
        if(fundRec.CampaignId!=null){
            campaignIdSet.add(fundRec.CampaignId);
        }
        if(fundRec.Fund_Request_Contact__c!= null){
            contactIdSet.add(fundRec.Fund_Request_Contact__c);
        }
    }
    
    Map<Id,Account> accRecMap =new Map<Id, Account>( [Select Id, Name,OwnerId from Account where Id=:accIdSet]);
    Map<Id, Campaign> campaignMap = new Map<Id, Campaign>([Select Id, Name from Campaign where Id=:campaignIdSet]);
    Map<Id, Contact> contactMap = new Map<Id, Contact>([Select Id,Email, Phone from Contact where Id=:contactIdSet]);
    Map<String, Decimal> eligibleActivityByPercentMap = new Map<String, Decimal>();
    system.debug('accRecMap >>>'+accRecMap );
    for(PartnerFundRequest fundRec: fundRequests){
        if(fundRec.ChannelPartnerId != null){
            String companyName = '';
            String companySubstring = '';
            companyName = accRecMap.get(fundRec.ChannelPartnerId).Name;
            //system.debug('companyName >>>'+companyName );
            companySubstring =companyName.subString(0,5);
            fundRec.Title= companySubstring+'-'+fundRec.MDF_Activity_Code__c;
            fundRec.Company_Name__c = companyName;
            fundRec.Partner_Account_Manager__c = accRecMap.get(fundRec.ChannelPartnerId).OwnerId;
            if(campaignMap.containsKey(fundRec.CampaignId)){
                fundRec.Campaign_Name__c= campaignMap.get(fundRec.CampaignId).Name;
            }
            
            if(contactMap.containsKey(fundRec.Fund_Request_Contact__c)){
                fundRec.Fund_Contact_Phone__c= contactMap.get(fundRec.Fund_Request_Contact__c).Phone;
            }
            if(fundRec.Partner_Account_Manager__c != null){
                Map<Id, PartnerFundRequestApprovers__mdt> pamIdByMetadataRecordMap = getApproverMetadata(fundRec.Partner_Account_Manager__c);
                if(pamIdByMetadataRecordMap.containsKey(fundRec.Partner_Account_Manager__c)){
                    fundRec.MDF_Administrator__c = pamIdByMetadataRecordMap.get(fundRec.Partner_Account_Manager__c).MDF_Administrator_Id__c;
                    fundRec.Management_Approver__c = pamIdByMetadataRecordMap.get(fundRec.Partner_Account_Manager__c).Management_Approver_Id__c;
                }
            }
            
            eligibleActivityByPercentMap = getReimbursementPercentMetadata(fundRec.Eligible_Activities_Activity_Type__c);
            system.debug('eligibleActivityByPercentMap >>> '+eligibleActivityByPercentMap );
            if(eligibleActivityByPercentMap.containsKey(fundRec.Eligible_Activities_Activity_Type__c)){
                fundRec.Reimbursement__c = eligibleActivityByPercentMap.get(fundRec.Eligible_Activities_Activity_Type__c);
            }
        }
    }
        
    }
    
    
    
    public static Map<Id, PartnerFundRequestApprovers__mdt> getApproverMetadata(Id pamId){
        
        Map<Id, PartnerFundRequestApprovers__mdt> pamIdByMetadataRecordMap = new Map<Id, PartnerFundRequestApprovers__mdt>(); 
        List<PartnerFundRequestApprovers__mdt>  approversMetadataList = [select Id,DeveloperName,MasterLabel,Management_Approver__c,Management_Approver_Id__c,MDF_Administrator__c,MDF_Administrator_Id__c, PAM_Approver__c,PAM_Approver_Id__c from PartnerFundRequestApprovers__mdt where PAM_Approver_Id__c =:pamId];
        
        for(PartnerFundRequestApprovers__mdt aaproversRec: approversMetadataList ){
            pamIdByMetadataRecordMap.put(aaproversRec.PAM_Approver_Id__c , aaproversRec);
        }
        return pamIdByMetadataRecordMap;
    }
    
    public static Map<String, Decimal> getReimbursementPercentMetadata(String eligibleActivity){
        system.debug('eligibleActivity>>> '+eligibleActivity);
        Map<String, Decimal> eligibleActivityByPercentMap = new Map<String, Decimal>(); 
        List<PartnerFundRequestReimbursement__mdt>  percentageMetadataList = [select Id,DeveloperName,MasterLabel,Reimbursement__c,Eligible_Activities_Activity_Type__c from PartnerFundRequestReimbursement__mdt where Eligible_Activities_Activity_Type__c =:eligibleActivity];
        
        for(PartnerFundRequestReimbursement__mdt aaproversRec: percentageMetadataList){
            eligibleActivityByPercentMap.put(aaproversRec.Eligible_Activities_Activity_Type__c , aaproversRec.Reimbursement__c);
        }
        return eligibleActivityByPercentMap;
    
    }
}