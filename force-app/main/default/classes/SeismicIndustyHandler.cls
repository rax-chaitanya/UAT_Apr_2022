/**********************************************************************************

Author: Vinod Thupakula
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class SeismicIndustyHandler implements TriggerInterface{
 public Boolean isActive()
    {
         if(Trigger_Manager__c.getAll().containsKey('SeismicIndustyTgr')) {
            return Trigger_Manager__c.getInstance('SeismicIndustyTgr').Is_Active__c;
         }
         return false;
    }
    
    public void beforeInsert() 
    {
         
    }
    
    public void beforeUpdate() 
    {
         
    }
    
    public void beforeDelete() {}
    
    public void afterInsert(){
        
        Map<String,String> seismicSettings= new Map<String,String>();
        for(Seismic_Industry_Mapping__c seismic:(List<Seismic_Industry_Mapping__c>)Trigger.new){
            if(String.isNotBlank(seismic.Industry__c))seismicSettings.put(seismic.Industry__c,seismic.Seismic_Name__c);
        }
        if(seismicSettings.size()>0){Database.executebatch(new SeismicIndustryBatch(seismicSettings),200);} 
         
    }
    
    public void afterUpdate() {
        Map<String,String> seismicSettings= new Map<String,String>();
        Map<Id,Seismic_Industry_Mapping__c> oldSeismics = (Map<Id,Seismic_Industry_Mapping__c>)Trigger.oldMap;
        for(Seismic_Industry_Mapping__c seismic:(List<Seismic_Industry_Mapping__c>)Trigger.new){
            if(String.isNotBlank(seismic.Industry__c))seismicSettings.put(seismic.Industry__c,seismic.Seismic_Name__c);
            if(String.isNotBlank(seismic.Industry__c) && oldSeismics.get(seismic.Id).Industry__c != seismic.Industry__c)seismicSettings.put(oldSeismics.get(seismic.Id).Industry__c,seismic.Seismic_Name__c);
        }
        if(seismicSettings.size()>0){Database.executebatch(new SeismicIndustryBatch(seismicSettings),200);} 
    }
    
    public void afterDelete() {
        Map<String,String> seismicSettings= new Map<String,String>();
        for(Seismic_Industry_Mapping__c seismic:(List<Seismic_Industry_Mapping__c>)Trigger.old){
            if(String.isNotBlank(seismic.Industry__c))seismicSettings.put(seismic.Industry__c,'');
        }
        if(seismicSettings.size()>0){Database.executebatch(new SeismicIndustryBatch(seismicSettings),200);}
    }
    
    public void afterUndelete() {}
}