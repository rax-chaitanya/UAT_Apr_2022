public class ProjectExtensionController {
    
    public Project__C newProj = new Project__c();
    public String rType{get;set;}
    public String rTypeName{get;set;}
    public String Projid{get;set;}
    public pageReference pr;
    public boolean showerror{set;get;}
    public ProjectExtensionController(ApexPages.StandardController controller)
    { 
        this.newProj = (Project__c)controller.getRecord();
        Projid = ApexPages.currentPage().getParameters().get('id');
        rType = ApexPages.currentPage().getParameters().get(Label.RecordTypeLabel);
        showerror = false;  
        if(rType!=NULL)
            rTypeName = [select ID, Name From RecordType Where id=:rType].Name;    
        
        if(projid==null)
            newProj.recordtypeid=rType;   
    }
    
    
    public pageReference save()
    {
        showerror = false;
        if (newproj.Proposal_Stage__c =='Pre Qualify'){
            newproj.Probability__c = '5%';
            newproj.Forecast__c = 'Pipeline';
        } 
        else if(newproj.Proposal_Stage__c =='Qualify'){
            newproj.Probability__c = '5%';
            newproj.Forecast__c = 'Pipeline';
        }
        
        else if(newproj.Proposal_Stage__c =='Scope'){
            newproj.Probability__c = '20%';
            newproj.Forecast__c = 'Pipeline';
        }
         else if(newproj.Proposal_Stage__c =='Proposal & Quote'){
            newproj.Probability__c = '50%';
            newproj.Forecast__c = 'Best Case';
        }
        else if(newproj.Proposal_Stage__c =='Proposal & Quote - Modifications'){
            newproj.Probability__c = '85%';
            newproj.Forecast__c = 'Best Case';
        }        
        else if(newproj.Proposal_Stage__c =='Final Legal'){
            newproj.Probability__c = '90%';
            newproj.Forecast__c = 'Commit';
        }       
        else if(newproj.Proposal_Stage__c =='Won - Signed Agreement'){
            newproj.Probability__c = '100%';
        }       
        else
        {
            newproj.Probability__c = '0%';
            newproj.Forecast__c = 'Omitted';
        }
        
        
        if (newproj.PS_Time_Discounted__c && newproj.Discount_Approver__c == NULL)
        {
            newproj.Discount_Approver__c.addError(Label.ProjectDiscountApproverRequired);
            showerror = true;
            return null;
        }        
        else if(newproj.Commissions__c == 'YES' && newproj.Commission_Percentage__c==NULL)
        {
            newproj.Commission_Percentage__c.addError(Label.ProjectCommissionPercentageRequired);
            showerror = true;
            return null;
        }       
        else if(newproj.Proposal_Stage__c =='Lost' && newproj.INTL_Project_Lost_Reason__c == NULL)
        {
            newproj.INTL_Project_Lost_Reason__c.addError(Label.ProjectIntlLostReasonRequired);
            showerror = true;
            return null;
        }
        else{
            newproj.RecordTypeId=rtype;
          upsert newproj; 
            
            if(projid == NULL)
            {  
                projid=newproj.id; 
                            
                Project__c tempproj = [Select id, Milestone_Description__c, Milestone_Due_Date__c, Partner_Fee__c, RAX_Partner_Margin_Amount__c,
                                       RAX_PM_Amount__c, Contact__c, Project_Role__c, Project_Role_Contact_Notes__c,
                                       Contact_2__c, Project_Role_2__c, Project_Role_Contact_Notes_2__c,Practice__c
                                       From Project__c Where id=: projid];
                
                Project_Pricing__c ProjMlst = new Project_Pricing__c();
                
                ProjMlst.Project__c = tempproj.id;
                ProjMlst.Name = tempproj.Milestone_Description__c;
                ProjMlst.Due_Date__c = tempproj.Milestone_Due_Date__c;
                ProjMlst.Partner_Fee__c = tempproj.Partner_Fee__c;
                ProjMlst.RAX_Partner_Margin__c = tempproj.RAX_Partner_Margin_Amount__c;
          
                Project_Role_Resources__c ProjRR = new Project_Role_Resources__c();
                
                ProjRR.Contact__c = tempproj.Contact__c;
                ProjRR.Project__c = tempproj.id;
                ProjRR.Resource_Role__c = tempproj.Project_Role__c;
                ProjRR.Project_Role_Contact_Notes__c = tempproj.Project_Role_Contact_Notes__c;
                
                
                Project_Role_Resources__c ProjRR2 = new Project_Role_Resources__c();
                
                ProjRR2.Contact__c = tempproj.Contact_2__c;
                ProjRR2.Project__c = tempproj.id;
                ProjRR2.Resource_Role__c = tempproj.Project_Role_2__c;
                ProjRR2.Project_Role_Contact_Notes__c = tempproj.Project_Role_Contact_Notes_2__c;
                
                insert ProjMlst;
                insert ProjRR;
                insert ProjRR2;
            }
            
            pr = new pageReference('/apex/ProjectEMEAProServView').setRedirect(true);
            pr.getParameters().put('id', projid);
           return pr;
            
        }
    }
    
    public pageReference Cancel()
    {
        return new pageReference(Label.ProjectListViewURL).setRedirect(true);
    } 
    
    public pageReference Cancel1()
    {
        pageReference returnpage = new pageReference('/apex/ProjectEMEAProServView').setRedirect(true);
        returnpage.getParameters().put('id', projid);
        return returnpage;
    } 
}