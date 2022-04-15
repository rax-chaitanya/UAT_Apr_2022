public without sharing class PartnerAgreementsController {
    @AuraEnabled
    Public static Object getAgreements(){
        Map<String,String> result = new Map<String,String>();
        result.put('Us_Reseller',getAgreement(Label.Reseller_AgreementId));
        result.put('Us_Referral',getAgreement(Label.US_Referral_AgreemntId));
        //result.put('Us_Strategic',getAgreement(Label.US_StrategicAgreementId));
        result.put('Intl_Reseller',getAgreement(Label.INTL_ResellerAgreementId));
        result.put('Intl_Referral',getAgreement(Label.INTL_ReferralAgreementId));
        result.put('Intl_Strategic',getAgreement(Label.INTL_StrategicAgreementId));
       
        return result;
    }
    @AuraEnabled
    public static String getAgreement(String Labelvalue){
       return [SELECT DistributionPublicUrl,createdDate,ContentDownloadUrl FROM ContentDistribution where contentDocumentId =: Labelvalue order by createdDate desc limit 1].DistributionPublicUrl;
        
    }
}