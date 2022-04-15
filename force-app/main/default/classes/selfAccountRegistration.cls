/**
* File : selfAccountRegistration.cls
* Description : Sign up form partner portal.
* Ticket : SFDC-2210(Parent story - )
* Created Date : May 2018
* @author : RDC (Thirupathi,Biswa)
*/
public class selfAccountRegistration {
   
    
  /*  public String[] workLoad_MycheckBoxField { 
    get {return getMultipicklistField(con,'Supporting_Workloads__c');}
    set {setMultipicklistField(con,'Supporting_Workloads__c',value);}
} 
    public String[] geographicArea_MycheckBoxField { 
    get {return getMultipicklistField(con,'Covering_Geographic_Areas__c');}
    set {setMultipicklistField(con,'Covering_Geographic_Areas__c',value);}
} 
    public String[] SpecializedTech_MycheckBoxField { 
    get {return getMultipicklistField(con,'Specialized_Technology__c');}
    set {setMultipicklistField(con,'Specialized_Technology__c',value);}
}*/ 
    public Account acc {set;get;}
    public Contact con{set;get;}
    public boolean isRegistered {set;get;}
    public boolean req {get;set;}
    public String affliateUrl{get;set;}
    
    public selfAccountRegistration(ApexPages.StandardController accontroller) {
        acc = (Account) accontroller.getRecord();
        req = true;
        if(acc == null)
            acc = new Account(); 
        con=new Contact();
        //leadReg = new Lead();
        
        isRegistered = false;
        getAffliateUrl();
    }
    public List<SelectOption> getSelectionOptions(Sobject Obj, String PicklistFieldName){
    Schema.sObjectType sobject_type = Obj.getSObjectType();
    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

    List<Schema.PicklistEntry> pick_list_values = field_map.get(PicklistFieldName).getDescribe().getPickListValues();
    List<selectOption> options = new List<selectOption>();

    for (Schema.PicklistEntry a : pick_list_values) {
        
        SelectOption so = new selectOption(a.getLabel(), a.getValue());
        options.add(so);
       
    }

    return options;
}

// As per SFDC-2210 Commented the code.

/*String[] getMultipicklistField(SObject obj,String FieldName){
    String[] selected = new List<String>();
    List<SelectOption> sos = getSelectionOptions(obj,FieldName);
    for(SelectOption s : sos) {
        if (obj.get(FieldName) !=null && String.valueOf(obj.get(FieldName)).contains(s.getValue()))
            selected.add(s.getValue());
    }
    return selected;
    
    }*/


/*void setMultipicklistField(SObject obj,String FieldName,String[] ValueList){
        String selectedCheckBox = '';
        for(String s : ValueList) {
            if (selectedCheckBox == '') 
                selectedCheckBox += s;
            else 
                selectedCheckBox += ';' + s;
        }
        obj.put(FieldName,selectedCheckBox);
}


public List<SelectOption> getMyWorkloadItems(){
    
    return getSelectionOptions(con,'Supporting_Workloads__c');
}
    
public List<SelectOption> getMyGeographicAreas(){
    
    return getSelectionOptions(con,'Covering_Geographic_Areas__c');
}
 public List<SelectOption> getMySpecializedTechs(){
    
    return getSelectionOptions(con,'Specialized_Technology__c');
}*/
    
public PageReference createAccountContact(){
        acc.Primary_Member_Email__c=con.Email;
        acc.Primary_Member_First_Name__c=con.FirstName;
        acc.RecordTypeId =Label.Company_Partner_RecordTypeID;
        //SFDC-1677: As per the user story, i have commented the below line of code
       //Commnted By: Vinod Thupakula
       // acc.Type__c = 'Partner';
        acc.Partner_License_Type__c = 'Partner Community Login';
        if(acc.Program_Of_Interest__c.contains('Referral/Reseller')){
            acc.Partner_Level__c = 'Referral/Reseller';
        }
        else if(acc.Program_Of_Interest__c.contains('Referral')){
                    acc.Partner_Level__c = 'Referral';
        }
        else if(acc.Program_Of_Interest__c.contains('Reseller')){
                    acc.Partner_Level__c = 'Reseller';
        }
    AccountTeamMember Accteam = new AccountTeamMember();
    
    try{
        insert acc;
        con.AccountId=acc.Id;
        con.Is_Primary_Member__c = True;
        con.RecordTypeId=Label.Contact_Partner_RecordTypeID;
        con.MailingCountryCode=acc.BillingCountryCode;
        con.MailingStateCode=acc.BillingStateCode;
        con.MailingCity=acc.BillingCity;
        con.MailingPostalCode=acc.BillingPostalCode;
        con.MailingStreet=acc.BillingStreet;
        //con.MailingAddress=acc.BillingAddress;
        insert con;
        acc.IsPartner=true;
        acc.Primary_Member__c = con.Id;
        update acc;
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Some thing went wrong.Please Contact Rackspace'));
       ExceptionHandler.postToAll(e, true);
        return null;
       // throw new AuraHandledException(e.getDmlMessage(0));
         
    }
    isRegistered=true;
    
    return null;
}
    
  public void getAffliateUrl(){
  OrgConstants__c org = OrgConstants__c.getValues('Affiliate Registration');
                ProdOrgIDSetting__c pid = ProdOrgIDSetting__c.getOrgDefaults();
                
                Id userOrgId = UserInfo.getOrganizationId();
                
                req=false;
                //String url;
                
                if(!(pid.ProdOrgID__c.contains((String)userOrgId))){
                    //url=org.Non_Prod_Value__c; 
                    affliateUrl=org.Non_Prod_Value__c;            
                }
                else{
                    //url=org.Prod_Value__c;
                    affliateUrl=org.Prod_Value__c;
                }
  }  

  /*public PageReference checkAffiliate() {
            if(acc.Program_Of_Interest__c.contains('Affiliate')){
                OrgConstants__c org = OrgConstants__c.getValues('Affiliate Registration');
                ProdOrgIDSetting__c pid = ProdOrgIDSetting__c.getOrgDefaults();
                
                Id userOrgId = UserInfo.getOrganizationId();
                
                req=false;
                String url;
                
                if(!(pid.ProdOrgID__c.contains((String)userOrgId))){
                    url=org.Non_Prod_Value__c; 
                    //affliateUrl=org.Non_Prod_Value__c;            
                }
                else{
                    url=org.Prod_Value__c;
                    //affliateUrl=org.Prod_Value__c;
                }
                PageReference acctPage = new PageReference(url);
                acctPage.setRedirect(true);
                return acctPage;
            
            }
        else{
            return null;
        }
  }*/
    
  public PageReference cancel(){
        
         OrgConstants__c org = OrgConstants__c.getValues('Redirect To Rackspace Partner Site');
                ProdOrgIDSetting__c pid = ProdOrgIDSetting__c.getOrgDefaults();
                
                Id userOrgId = UserInfo.getOrganizationId();
                
                req=false;
                String url;
                
                if(!(pid.ProdOrgID__c.contains((String)userOrgId))){
                    url=org.Non_Prod_Value__c;                
                }
                else{
                    url=org.Prod_Value__c;
                }
                PageReference acctPage = new PageReference(url);
                acctPage.setRedirect(true);
                return acctPage;
            
            }
       

}