/**
 * @last modified on  : 09-07-2021
 * @last modified by  : Atheer Bdaiwi
**/
public class OpportunityLostController extends Framework{
    
    Opportunity opportunity{get; set;}
    Opportunity_Competitor__c OppNewComp{get; set;}
    Opportunity_Competitor__c OppEditComp{get; set;}
    public String compid{get;set;}
    //public List <Opportunity_Competitor__c> OppCompList{get; set;}
    public ID Opportunityid {get; set;}
    public Boolean success{get;set;}
    public Boolean StrNewComp{get;set;}
    public boolean StrEditComp{get;set;}
    
    
    public String recordID {get; set;}
    
    
    public boolean isRequired  {get;set;}{isRequired=false;}
    
    
    public Boolean showCompetitor {get; set;}
    
    public PageReference checkRequired(){
        System.debug('checkRequired()');
        //Your logic to check if the appropriate pick list values have been set for the input field
        Set<String> lostReasons = new Set<String>
        {'Contract & SLA Terms', 'Datacenter locations', 'Deployment Time', 'Price',
            'Product/Service Limitation', 'Project Abandoned', 'Support Incident', 'Churning'
            };
                if (lostReasons.contains(opportunity.Lost_Reason__c)) {
                    isRequired = true;
                    
                }
        return null;
    }    
    
    
    
    
    public list<string> getErrorMessages() {
        list<string> ret = new list<string>();        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //  @developer   :  Diego Castro
        //  @date        :  06/27/2017
        //  @story       :  https://jira.rax.io/browse/SFDC-43
        //  @description :  When an opportunity it "Closed Lost" then the question is required if the answer
        //                  selected is "Closed via ticket" OR "Existing Opps" OR "Project cancelled/postponed"
        //                  then all subsequents questions do not need to be displayed.
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (!Label.CL_WDWL_Hide_on_Select.contains(opportunity.Why_Did_We_Lose__c)) {
            //////////////////////          END OF SFDC-43          //////////////////////////////////////////////////
            Set<String> fields = new set<string>();
            Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() limit 1];//SFDC-2948
            // fields.add('Pain_Point__c'); raj: SFDC-1469
            //fields.add('What_did_we_do_well__c'); raj: SFDC-1469
            if(!Label.Seller_Profiles.contains(userProfile.Name))fields.add('Competitors__c');//SFDC-2948
            fields.add('Product_or_Service_limitation_gaps__c');
            
            //commented by:Vinod Thupakula
            //SFDC-2208
           /* List<Profile> ListProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() and Name like '%INTL'];
            if(ListProfile.size()>0 && OppCompList.size()<=0)
            {
                ret.add('Competitor must be captured');
            }
            */
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Opportunity.fields.getMap();
            
            for (String field : fields) {
                if (String.isBlank((string) opportunity.get(field))) {
                    ret.add(M.get(field).getDescribe().getLabel() + ' is required.');
                }
            }
            
        }
//Added if condition by Saswati for SFDC-3360 (commented out due to Case #)
//if(String.isEmpty(opportunity.Support_Offers_Pitched__c)&& Label.OppTypes_FAWS_Tracker.contains(opportunity.type)){
//      ret.add('Support offers must be captured');
//  }
//End
        return ret; 
    }    
    
    
    public OpportunityLostController()
    {
        super('OppCloseLostWizard');
        Opportunityid = ApexPages.currentPage().getParameters().get('id');
        
        
        setOpportunity();
        //LoadCompetitors();
        success=false;
        StrNewComp=false;
        StrEditComp=false;
    }
    
    public PageReference changeLostReason() {
        System.debug('lost reason: ' + recordId);
        opportunity.Lost_Reason__c = recordId;
        showCompetitor = (recordID == 'Competitor') ? true : false;
        isRequired = !showCompetitor;
        System.debug(opportunity.Lost_Sub_Reason__c);
        //StrNewComp = true;
        return null;
    }
    
    public void setOpportunity() {
        opportunity  = [Select Id, Name, Type,Account__r.Status__c, StageName, Account__c,
                        Lost_Reason__c, Why_Did_We_Lose__c, Focus_Area__c, Price__c, Product_or_Service_limitation_gaps__c,  Why_Did_We_Lose_Other__c, Pain_Point__c, What_Did_We_Do_Well__c,
                        What_Did_We_Do_Well_Other__c, Competitors__c, Competitors_Other__c, RAX_Usage_Reason__c, How_Were_They_Doing_It__c, 
                         FAWS_Reason__c, Pain_Point_Other__c, CloseDate                         
                        from Opportunity where Id = :opportunityId];
        opportunity.StageName = 'Closed Lost';
        
    }
    
    public Opportunity getOpportunity() {
        return opportunity;
    }
    
    public Opportunity_Competitor__c  getOppNewComp() {
        OppNewComp = new Opportunity_Competitor__c();
        return OppNewComp;
    }
    public Opportunity_Competitor__c  getOppEditComp() {
        //compid= ApexPages.currentPage().getParameters().get('oppcomid');
        SYstem.debug('opp competitor id is now: ' + recordID);
        try {
            OppEditComp = [Select Id, Category__c,Name,Description__c,Competitive_Bid__c,Competitor_Salesperson__c,Incumbent__c,
                           Opportunity__c,Strengths__c,Weaknesses__c,Won__c from Opportunity_Competitor__c where id=:recordID];
        } catch (Exception e) {
            
            
        }
        
        return OppEditComp;
    }
    /*public void LoadCompetitors()
    {
        OppCompList=[Select Id, Category__c,Name,Description__c,Competitive_Bid__c,Competitor_Salesperson__c,Incumbent__c,
                     Opportunity__c,Strengths__c,Weaknesses__c,Won__c from Opportunity_Competitor__c where Opportunity__c=:Opportunityid];
    }*/
    public void NewCompetitor() {
        
        StrNewComp=true;
        StrEditComp=false;
    }
    public PageReference EditCompetitor() {
        getOppEditComp();
        
        StrEditComp=true;
        StrNewComp=false;
        return null;
        
    }
    
    public PageReference exitPage() {
        return new PageReference('/' + opportunityid);
    }
    
    public void SaveNewComp() {
        
        
        OppNewComp.Opportunity__c=Opportunityid;
        insert OppNewComp;
       // LoadCompetitors();
        StrNewComp=false;
        
    }
    public void cancel() {
        
        StrNewComp=false;
        StrEditComp=false;
        
    }
    public void Edit() {
        
        update OppEditComp;
       // LoadCompetitors();
        StrEditComp=false;
    }
    
    public PageReference saveOpp() {
        System.debug('saveOpp()');
        
        try{
            
            
            System.debug('opportunity stage name: ' + opportunity.StageName + '... opportunity lost reason: ' + opportunity.Lost_Reason__c + ', sub reason: ' + opportunity.Lost_Sub_reason__c);
            
            list<string> errorMessages = getErrorMessages();
            if (errorMessages.size() > 0) {   
                for (String errorMsg : errorMessages) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg ); 
                    ApexPages.addMessage(myMsg); 
                }
            }
            
            
            else
            {
                
                opportunity.id=Opportunityid;
                //opportunity.RecordTypeId = OrgConstants__c.getInstance('Read Only Opportunity RecordTypeId').Prod_Value__c;
                
                
                
                List<SObject> toUpdate = new List<SObject>();
                toUpdate.add(opportunity);
                if (String.isNotBlank(opportunity.Account__c)) {
                    System.debug(opportunity.Account__c);
                    //had to remove the below lines due to SFSB-596
                    //opportunity.Account__r.Status__c = 'Inactive';
                    //toUpdate.add(opportunity.Account__r);
                }
                update toUpdate;
                
                
                showCompetitor = true;
                
                            return exitPage();

            }
            
        }
        
        catch(exception e) {
            ExceptionHandler.postToAll(e, false);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Occured while updating the Opportunity '+e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
        
        
    }
    
}