/********************************************************************************************************
* @developer   :    Diego Castro
* @date        :    05/31/17
* @class       :    UpdateChildRelationshipsBatch
* @description :    For a given sObject, this class will find the relevant child
*                   relationships and perform a
*                   dummy update on the records that have the linkage field blank. OBMs will be retriggered.
*********************************************************************************************************/
global class UpdateChildRelationshipsBatch implements Database.Batchable<sObject> {  
    
    global sObject[] start(Database.BatchableContext BC) {
        sObject[] records = new List<SObject>();
        Id ProspectTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Id CustomerTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        Id GovernmentTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Account').getRecordTypeId();
        Id RBUTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RBU Account').getRecordTypeId();
        Id ReadOnlyTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Read Only Account').getRecordTypeId();

        
        try {
            SObject[]   leads                       = [Select Id from Lead Where Old_Record_Id__c = ''];
           // sObject[]   opportunities               = [Select Id from Opportunity where Account__r.Old_Record_Id__c != ''];
             sObject[]   opportunities               = [Select Id from Opportunity]; 
            //////////////////////////////////////////////////////////////////////////////////////////////////
            // @developer   :    Diego Castro
            // @date        :    01/02/2018
            // @story       :    SFDC-XXX
            // @description :    Collect action record Ids were stamped from a cLog within the last 3 days.
            //////////////////////////////////////////////////////////////////////////////////////////////////
            set<string> action_record_ids = new set<string>(); 
            
            String fmwFoundationUser = Label.FMWFoundationUser ;    // used for query below   [Id=00561000001zo2k]                    
            for (AggregateResult ar : Database.query(String.format('Select Action_record_id__c from clog__c where createddate = {0} and  createdbyid = :fmwFoundationUser and action_record_id__c != null group by action_record_id__c LIMIT 2000',new list<string>{Label.UCRB_CreatedDate})))
            {
                action_record_ids.add(String.valueOf ((String) ar.get('Action_Record_ID__c')));
                //action_record_ids.add(String.valueOf ((String) ar.get('expr0')));
            }
        //     sObject[]   accounts                    = [Select Id from Account where Old_Record_Id__c = '' and Id not in :action_record_ids and (RecordTypeId =: ProspectTypeId OR RecordTypeId =: CustomerTypeId OR RecordTypeId =: GovernmentTypeId OR RecordTypeId =: RBUTypeId OR RecordTypeId =: ReadOnlyTypeId) ];
            sObject[]   accounts                    = [Select Id from Account where Id not in :action_record_ids and (RecordTypeId =: ProspectTypeId OR RecordTypeId =: CustomerTypeId OR RecordTypeId =: GovernmentTypeId OR RecordTypeId =: RBUTypeId OR RecordTypeId =: ReadOnlyTypeId) ];
         //   sObject[]   account_contact_roles       = [Select Id from Account_Contact_Role__C where Old_Record_Id__c = '' AND Account__r.Old_Record_Id__c != '' and Id not in :action_record_ids];
             sObject[]   account_contact_roles       = [Select Id from Account_Contact_Role__C where Old_Record_Id__c = ''  and Id not in :action_record_ids];
            
            //////////////////////////////////////////////////////////////////////////////////////////////////            
            
           // SObject[]   tasks_lead                  = [Select Id from Task where Old_Record_Id__C = '' and IsRecurrence = FALSE and WhoId in (Select Id from Lead where IsConverted = False AND Old_Record_Id__C != '' AND Status != 'Converted In Old'  )];
            SObject[]   tasks_lead                  = [Select Id from Task where  IsRecurrence = FALSE and WhoId in (Select Id from Lead where IsConverted = False AND Old_Record_Id__C != '' AND Status != 'Converted In Old'  )];
            //SObject[]   tasks_opps                  = [Select Id from Task where Old_Record_Id__c = '' and IsRecurrence = FALSE and WhatId in (Select Id from Opportunity Where Old_Record_Id__c != '')];
           //SObject[]   tasks_accs                  = [Select Id from Task where Old_Record_Id__c = '' and IsRecurrence = FALSE and WhatId in (Select Id from Accounts__c Where Old_Record_Id__c != '')];            
            SObject[]   tasks_accs                  = [Select Id from Task where IsRecurrence = FALSE and WhatId in (Select Id from Accounts__c Where Old_Record_Id__c != '')];            
            
            
            Sobject[]   campaign_members            = [Select Id from CampaignMember where Old_Record_Id__C = '' and Campaign.Old_Record_Id__c != '' and  LeadId in (Select Id from Lead where IsConverted = False AND Old_Record_Id__C != '' AND Status != 'Converted In Old') ];
            sObject[]   partner_roles               = [Select Id from Partner_Role__c where Old_Record_Id__C = ''];
            
            //sObject[]   specialists                 = [Select Id from Specialist__c where Old_Record_Id__C = '' AND Lead__r.Old_Record_Id__C != ''];
            //sObject[]   quotes                      = [Select Id from Quote__c where Old_Record_Id__c = '' AND Opportunity__r.Old_Record_Id__c != ''];
            //sObject[]   quote_lines                 = [Select Id from Quote_Line__c where Old_Record_Id__c = '' AND Opportunity_Quote__r.Old_Record_Id__c != ''];
            //sObject[]   sales_support_portfolios    = [Select Id from Sales_Support_Portfolio__c where Old_Record_Id__c = '' and Opportunity__r.Old_Record_id__c != ''];
            //sObject[]   deal_center_requests        =   [Select Id from Deal_Center_Request__c where Old_Record_Id__c = '' and Opportunity__r.Old_Record_Id__c != ''];
            
            
            records.addAll(leads);
            records.addAll(accounts);
            records.addAll(opportunities);
            
            records.addAll(account_contact_roles);
            records.addAll(tasks_lead);
           // records.addAll(tasks_opps);
            records.addAll(tasks_accs);
            
            
            records.addAll(campaign_members);
            records.addAll(partner_roles);
            
        } catch (Exception e) {
            ExceptionHandler.postToChatter(e);
            
        }
        return records;
    }    
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            if (scope.size() > 0) {
                scope.sort();                
                Database.update(scope, false);
            }
        } catch (Exception e) {
            ExceptionHandler.postToChatter(e);
        }
    }
    
    
    global void finish(Database.BatchableContext BC) {
        if(!Test.isRunningTest()) {
            try {
                System.scheduleBatch(new UpdateChildRelationshipsBatch(), 'UpdateChildRelationshipsBatch', 1);
            }
            catch(Exception e) { 
                System.scheduleBatch(new UpdateChildRelationshipsBatch(), 'UpdateChildRelationshipsBatch', 5);
            }
        }
        
    }
    
}