global class UpdateDNBCompanyNameonleadBatch implements Database.Batchable<sobject>
{
      // Start Method
    List<lead> updatedRecords = new List<lead>();
    List<ErrorLog__c> errorslistnew =new  List<ErrorLog__c>();
    Database.SaveResult [] updateRecs;
    global Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name, D_B_Company_Name__c,Company from Lead where D_B_Company_Name__c= null AND IsConverted=False');      
    }
    global void execute (Database.BatchableContext BC, List<lead> llist) {
         updatedRecords = new List<lead>();
         errorslistnew = new List<ErrorLog__c>();
         for(lead l:llist)
         {
           if(l.Company!=null)
           {           
               l.D_B_Company_Name__c=l.Company;
           }         
         }
        if(llist.size() > 0){
            updateRecs = Database.update(llist, false);            
            for(Integer i=0;i<updateRecs.size();i++){
                if (!updateRecs.get(i).isSuccess()){
                    Database.Error error = updateRecs.get(i).getErrors().get(0);                    
                    ErrorLog__c errorrecdetails = new Errorlog__c();
                    errorrecdetails.RecordID__c = (String)llist.get(i).Id;
                    errorrecdetails.Message__c = error.getMessage();                   
                    //errorrecdetails.DNB__c ='TRUE';
                    //errorrecdetails.Object_name__c = 'Lead';
                    errorslistnew.add(errorrecdetails);
                }                               
            }            
        }
        if(errorslistnew.size()> 0)
        {
            Database.insert(errorslistnew,false);
        }
	 }
     global void finish(Database.BatchableContext BC) {         
		updatedRecords = null;
         errorslistnew = null;
         updateRecs    = null;
}
}