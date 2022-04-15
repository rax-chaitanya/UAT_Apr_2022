/****
TestClass: MAP_EligibleAvtivitiesMatrixCtrl_Test
****/
public class MAP_EligibleAvtivitiesMatrixController { 
        
    @AuraEnabled
    public static String getPDFDocument(){ 
            ContentDistribution content = new ContentDistribution();
             ContentDocument contentDocRec = [SELECT Id, Title FROM ContentDocument where Title ='Eligible Activities Matrix' LIMIT 1];
             if(contentDocRec != null)
             content=[SELECT DistributionPublicUrl,id FROM ContentDistribution where contentDocumentId =:contentDocRec.Id LIMIT 1]; 
        return content.DistributionPublicUrl;
    }
}