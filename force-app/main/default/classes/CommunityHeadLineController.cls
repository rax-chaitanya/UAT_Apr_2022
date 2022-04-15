/*********************************************************************************
@Description        : This apex class is created for the provinding Head Line for Partners and partner operations users
@Class              : CommunityHeadLineController
@Author             : Venkateswararao Reddipalli(venkateswararao.reddipalli@rackspace.com)  
@Created Date       : 06-May-2019
@Lastmodified Date  : 10-Jul-2019
@Lastmodified By    : Ashok Cherapalli(ashokkumar.cherapalli@rackspace.com)
@Test Class         : CommunityHeadLineController_Test
**********************************************************************************/
public class CommunityHeadLineController { 
    /*********************************************************************************
@Description        : This method is used for to check the logged user is Admin or PartnerOps and Partner Contract Type 
@Parameter          : none
@Return             : String 
**********************************************************************************/
     @AuraEnabled
    public static String getUserInfo2(){
        String str= null;
        try{ 
            User loginUser = [SELECT Account.Membership_Level__c,Account.Membership__c,ProfileId FROM User WHERE Id = :UserInfo.getUserId()]; 
           system.debug('loginUserprofile------------'+loginUser.profileid);
            if(Label.Admin_Profiles.contains(loginUser.ProfileId)|| Label.PAM_and_Partner_Ops_Profile.contains(loginUser.ProfileId)){
                str= 'Admin';
            }
            else  if(loginUser.Account != null && String.isNotBlank(loginUser.Account.Membership_Level__c)){
                str= loginUser.Account.Membership__c;  
            }
             
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
        return str;
    } 
     
     @AuraEnabled
    public static Partner_Community_Data__c getExistingRecord2(String MembershipLevel){
    List<Partner_Community_Data__c> existingRecord= new   List<Partner_Community_Data__c>();
   system.debug('MembershipLevel------'+MembershipLevel);   
    existingRecord = [SELECT Id,Head_Line__c,Membership_Level__c FROM Partner_Community_Data__c WHERE Active__c=true AND Membership_Level__c INCLUDES(:MembershipLevel)  LIMIT 1];
    
    
        try{
            system.debug('---'+MembershipLevel);      
           if(existingRecord.size()>0)
            return existingRecord[0];
           
           
         }catch(Exception e){
            
        }
        return null;
    } 
    
    
    
    @AuraEnabled
    public static String updateHeadLineWithContractType2(String headline,String MembershipLevel,String recordId){
      Partner_Community_Data__c checkcompanyprofile=new Partner_Community_Data__c();
    
        try{
            system.debug('recordId'+recordId);
            if(String.isNotBlank(recordId) ){
                update new Partner_Community_Data__c(Id = recordId,Head_Line__c = headline,Active__c=true);
                return 'Success';
            }
            else{
                insert  new Partner_Community_Data__c(Head_Line__c = headline,Active__c=true,Membership_Level__c= MembershipLevel);
                return 'Success';
            }
        }catch(Exception e){
            
        }
        return null;
    }
    
    @AuraEnabled
    public static String getUserInfo(){
        String str= null;
        try{ 
            User loginUser = [SELECT Account.Contract_Type__c,ProfileId FROM User WHERE Id = :UserInfo.getUserId()]; 
            if(Label.Admin_Profiles.contains(loginUser.ProfileId)|| Label.PAM_and_Partner_Ops_Profile.contains(loginUser.ProfileId)){
                str= 'Admin';
            }
            else  if(loginUser.Account != null && String.isNotBlank(loginUser.Account.Contract_Type__c)){
                str= loginUser.Account.Contract_Type__c;  
            }
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
        return str;
    } 
    /*********************************************************************************
@Description        : This method is used for to get the object(Partner_Community_Data__c) related picklist values 
@Parameter          : String
@Return             : String 
**********************************************************************************/
    @AuraEnabled
    public static List<String> getPicklistvalues(String fieldAPIName){
        List<String> pickList = new List<String>();
        try{        
        if(String.isNotBlank(fieldAPIName)){
            Schema.DescribeSObjectResult objSchema = Partner_Community_Data__c.sObjectType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
            List<Schema.Picklistentry>fld =fieldmap.get(fieldAPIName).getDescribe().getpicklistValues(); 
            for(Schema.Picklistentry pl : fld){
                pickList.add(pl.getValue());
            }          
        } 
            }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
        return pickList;
    }
    /*********************************************************************************
@Description        : This method is used for to update or insert object(Partner_Community_Data__c) data 
@Parameter          : String
@Return             : String 
**********************************************************************************/
    @AuraEnabled
    public static void updateHeadLineWithContractType(String headline,String Contracttype,String recordId){
        try{
            if(String.isNotBlank(recordId)){
                update new Partner_Community_Data__c(Id = recordId,Head_Line__c = headline);
            }
            else{
                Id recordTypeId= Schema.SObjectType.Partner_Community_Data__c.getRecordTypeInfosByName().get('Header').getRecordTypeId();
                insert  new Partner_Community_Data__c(RecordTypeId=recordTypeId,Head_Line__c = headline,Contract_Type__c = Contracttype,Active__c=true);
            }
        }catch(Exception e){
            
        }
    }
    /*********************************************************************************
@Description        : This method is used for getting Existing Records from object(Partner_Community_Data__c) 
@Parameter          : String
@Return             : Partner_Community_Data__c  
**********************************************************************************/
    @AuraEnabled
    public static Partner_Community_Data__c getExistingRecord(String Contracttype){
        try{
        List<Partner_Community_Data__c> existingRecord = [SELECT Id,Head_Line__c,Contract_Type__c FROM Partner_Community_Data__c WHERE Active__c=true AND Contract_Type__c INCLUDES(:Contracttype) LIMIT 1];
        if(existingRecord.size()>0)
            return existingRecord[0];
            
         }catch(Exception e){
            
        }
        return null;
    } 
        @AuraEnabled
    public static Account getCompanyProfile(){
     
   Account company=new Account();
        User puser = [Select name,AccountId,id,contactid from User where id =: UserInfo.getUserId() limit 1];
        if(puser.AccountId!=null){
       
       company = [Select Id,Name,BillingCity,BillingState,BillingCountry,Website,ParentId,Description,Membership__c 
                           from Account where id = : puser.AccountId limit 1];
       }                    
        if(company!=null)
            return company;
        else 
            return null;
    }
      
}