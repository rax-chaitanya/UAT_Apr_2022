/*Creating to update owner and Recordtypes on Product accounts to the actual reocrd types*/
global class Ownerandrecordtypeupdatebatchclass implements Database.Batchable<sObject>,database.stateful{
    
    String query;
    //Getting all the Product Account record Types(Company)
    Id MigAccountRtid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Migration Record Account').getRecordTypeId(); 
    Id GovernmentAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Account').getRecordTypeId();
    Id ProspectAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();   
    Id CustomerAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId(); 
    Id RBUAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RBU Account').getRecordTypeId(); 
    Id ReadonlyAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Read Only Account').getRecordTypeId();
    
    //Getting all the Custom Account record Types
    Id ProspectRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
    Id GovernmentRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Government').getRecordTypeId();
    Id CustomerRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Id RBURtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
    Id ReadOnlyRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Read Only').getRecordTypeId();
    
    global Ownerandrecordtypeupdatebatchclass(){
        //Migration Record type:recordtypeid = \'0126w0000004HziAAE\''
        query = 'SELECT Id,old_RecordTypeId__c,Old_Owner_Id__c,ownerid,custom_account_sfdc_id__c,recordtypeid' +
            ' FROM Account' + ' WHERE custom_account_sfdc_id__c != null and recordtypeid =: MigAccountRtid';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('Query.........'+query);
        return Database.getQueryLocator(query);
       
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        list<account> acclist = new list<account>();
        for(Account ac : scope){
            ac.ownerid= ac.Old_Owner_Id__c;
            if( ac.old_RecordTypeId__c==ProspectRtid){
                ac.recordtypeid= ProspectAccountRtId;
            }
            else if( ac.old_RecordTypeId__c==GovernmentRtid){
                ac.recordtypeid= GovernmentAccountRtId;
            }
            else if( ac.old_RecordTypeId__c==CustomerRtid){
                ac.recordtypeid= CustomerAccountRtId;
            }
            else if( ac.old_RecordTypeId__c==RbuRtid){
                ac.recordtypeid= RBUAccountRtId;
            }
            else if ( ac.old_RecordTypeId__c==ReadonlyRtid){
                ac.recordtypeid= ReadonlyAccountRtId;
            }
            acclist.add(ac);
        }
        if (acclist.size() > 0){
            update acclist;
        }
                /*if (acclist.size() > 0){
        update acclist;
        Database.SaveResult [] updateResult = Database.update(acclist, false);
        for(Integer i=0;i<updateResult.size();i++){
        if (!updateResult.get(i).isSuccess()){
        Database.Error error = updateResult.get(i).getErrors().get(0);
        system.debug('Failed Record ID: '+acclist.get(i).Id + 'Error Message: '+ error.getMessage());
        ErrorLog__c errordetails=new Errorlog__c();
        errordetails.RecordID__c = (String)acclist.get(i).Id;
        errordetails.Message__c = error.getMessage();
        errordetails.Action_Type__c = 'Owner_and_Recordtype_Batch_GTMO';
        errorslist.add(errordetails);
        }
        
        }
        }
        if(errorslist.size()> 0){
        Database.insert(errorslist,false);
        }
        system.debug('errorslist....'+errorslist); */
    }
    global void finish(Database.BatchableContext BC){   
    }
}