public class AttachmentTriggerHelper {

   public static void AttchmentMethod(List<Attachment> AttList)
   {
        //****Commented the below code (Venkat-6/20/2107) because It will throw error (Now leads sync is happening trough FMW)
        //Sf2SfIntegrationHelper.publishAttachmentRecords(AttList,AttList[0].getsObjectType().getDescribe().getName());
        //***********
       //Added by venkat to update a filed on partner role when attachment is uploaded
    
       
       //collect all the parentId's into a set
       set<Id> pIds = new set<Id>();
    
       //list of all MDF's to be updated with the flag
       List<Partner_Role__c> toUpdate = new List<Partner_Role__c>();
    
       //Collect all parentIds
       for(Attachment a : AttList){
           pIds.add(a.parentId);
       }
    
       //Collect all MDF records with the above list of parentId's and it will return only MDF Records
       List<Partner_Role__c> PRList = new List<Partner_Role__c>();
       PRList = [select Id, Has_Attachment__c, Status__c from Partner_Role__c where id IN :pIds];
    
       if(!PRList.isEmpty())
       {
         for(Partner_Role__c PR : PRList)
         {
             PR.Has_Attachment__c = true;
             PR.Status__c='Pending Approval';
            
             toUpdate.add(PR);
         }
       } 
       if(toUpdate.size()>0){
           try {
               Update toUpdate;
           } catch (Exception e) {
               ExceptionHandler.postToAll(e);
               throw new CustomException(ExceptionHandler.getBody(e));     
           }
           
        
       }

   }
}