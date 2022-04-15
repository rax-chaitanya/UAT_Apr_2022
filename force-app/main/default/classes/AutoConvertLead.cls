public class AutoConvertLead {
    
    
    @InvocableMethod
    public static void autoConvertLeadtoCompany(List<Id> LeadIds){
        
        LeadStatus convertedStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        for(id currentlead: LeadIds){
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(currentlead);                
            Leadconvert.setConvertedStatus(convertedStatus.MasterLabel);
            leadsToConvert.add(Leadconvert);
        }
        
        if (!leadsToConvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadsToConvert);
            
        }
    }
    
}