/**
* Created by  : Venkat
* Created Date: 11/02/2016
* Description: This is the helper class for PartnerRoleTrigger
*  
* */

public class PartnerRoleTriggerHelper {
    
    public static List<Lead> UpdateLeads {get;set;}
    public static List<Opportunity> UpdateOpps {get;set;}
    
    //This method returns map of partner role records
    public static Map<id,list<partner_role__c>> Mapvalues(List<Partner_Role__c> Roles)
    {
        Map<id,list<partner_role__c>> MapApprovedRoles= new Map<id,List<partner_role__c>>();
        for(Partner_Role__c role:Roles)
        {       
            if(String.isNotBlank(role.lead__c))
            {
                MapvaluesSubMethod(role,role.lead__c,MapApprovedRoles);
            }
            if(String.isNotBlank(role.Opportunity__c))
            {
                MapvaluesSubMethod(role,role.Opportunity__c,MapApprovedRoles);
            }           
        }
        
        return MapApprovedRoles;
        
    }
    public static void MapvaluesSubMethod(Partner_Role__c role,String fieldName,Map<id,list<partner_role__c>> MapApprovedRoles)
    {
        if(MapApprovedRoles.containsKey(fieldName))
        {
            MapApprovedRoles.get(fieldName).add(role);
        }
        else
        {
            MapApprovedRoles.put(fieldName,new List<partner_role__c>{role});
        }
    }
    //This method is to restrict user to add more than two approved roles
    public static void ValidateInsertRoles(Map<id,list<partner_role__c>> MapApprovedRoles, List<partner_role__c> listInsertRoles)
    {
        
        for(partner_role__c p: listInsertRoles)
        {
            
            if(String.isNotBlank(p.lead__c) && MapApprovedRoles.containskey(p.lead__c))
            {
                ValidateInsertSubMethod(MapApprovedRoles,p,p.lead__c);
                
            }
            
            if(String.isNotBlank(p.Opportunity__c) && MapApprovedRoles.containskey(p.Opportunity__c))
            {
                
                ValidateInsertSubMethod(MapApprovedRoles,p,p.Opportunity__c);   
                
            }
        }
        
    }
    public static void ValidateInsertSubMethod(Map<id,list<partner_role__c>> MapApprovedRoles,Partner_Role__c PR,String fieldName)
    {
        if( MapApprovedRoles.get(fieldName).size()>=2)
        {
            PR.addError('Maximum of two approved partner roles can exist');
        }
        else
        {
            if(PR.role__c=='Source' && MapApprovedRoles.get(fieldName)[0].role__c=='Source')
            {
                PR.addError('There can only be one approved Source role');
            }
            
        }
    }
    //This method is to restrict user to update a role to avoid duplicate approved roles
    public static void ValidateUpdateRoles(Map<id,list<partner_role__c>> MapApprovedRoles, List<partner_role__c> listUpdateRoles,Map<id,partner_role__c> MapOldRoles)
    {
        if(!Test.isRunningTest())
        {       
        if(!userinfo.getuserid().contains(OrgConstants__c.getInstance('SFDC_TES_Admin').Prod_Value__c) && !userinfo.getuserid().contains(Label.FMWFoundationUser))
        {
        for(partner_role__c p: listUpdateRoles)
        {
            
            if(String.isNotBlank(p.lead__c) && MapApprovedRoles.containskey(p.lead__c))
            {
                ValidateUpdateSubMethod(MapApprovedRoles,p,p.lead__c,MapOldRoles);            
            }
            
            if(String.isNotBlank(p.Opportunity__c) && MapApprovedRoles.containskey(p.Opportunity__c))
            {
                ValidateUpdateSubMethod(MapApprovedRoles,p,p.Opportunity__c,MapOldRoles);            
            }
        }
        }
        } // Raj - SFDC#639
        
    }
    //Modified for SFDC-777 by Venkat
    public static void ValidateUpdateSubMethod(Map<id,list<partner_role__c>> MapApprovedRoles,Partner_Role__c p,String fieldName,Map<id,partner_role__c> MapOldRoles)
    {
        if(MapApprovedRoles.get(fieldName).size()==1)
        {
            
            if(((MapOldRoles.get(p.Id).role__c!='Source' && p.role__c=='Source'))&&(MapApprovedRoles.get(fieldName)[0].Role__c=='Source' && MapApprovedRoles.get(fieldName)[0].Status__c=='Approved'))
            {
                p.addError('Source with approved role already exist,Can not modify this record');
            }
            else if((p.Status__c=='Approved' && p.Role__c=='Source')&&(MapApprovedRoles.get(fieldName)[0].Role__c=='Source' && MapApprovedRoles.get(fieldName)[0].Status__c=='Approved'))
            {
               p.addError('Source with approved role already exist,Can not approve this record');
            }
            
            
        }
        
        else if(MapApprovedRoles.get(fieldName).size()==2)
        {
            //Partner_Role__c OtherRole=New Partner_Role__c();
            Partner_Role__c OtherApprovedSourceRole=New Partner_Role__c();
            for(Partner_role__c roles:MapApprovedRoles.get(fieldName))
            {
                /*if(p.id!=roles.id)
                {
                    OtherRole=roles;
                }*/
                if(roles.role__c=='Source')
                {
                   OtherApprovedSourceRole=roles;
                }
            }
            
            if(((MapOldRoles.get(p.Id).role__c!='Source' && p.role__c=='Source'))&&(OtherApprovedSourceRole.Role__c=='Source' && OtherApprovedSourceRole.Status__c=='Approved'))
            {
                p.addError('Source with approved role already exist,Can not modify this record');
            }
                      
            else if(p.Status__c=='Approved' && (p.Role__c=='Influence'||p.Role__c=='Source'))
            {
               p.addError('Maximum of two approved partner roles already exist,Can not approve this record');
            }
            

            
        }
    }
    //End of SFDC-777
    //This is method for send roles to approval
    public static void ApprovalMethod(Map<id,list<partner_role__c>> MapRoles,List<Partner_Role__c> RoleList)
    {
        for(Partner_Role__c p:RoleList)
        {
            
            if(String.isNotBlank(p.Opportunity__c) && MapRoles.containskey(p.Opportunity__c))
            {
                ApprovalSubMethod(MapRoles,p,p.Opportunity__c);            
            }
            else if(String.isNotBlank(p.lead__c) && MapRoles.containskey(p.lead__c))
            {
                ApprovalSubMethod(MapRoles,p,p.lead__c);            
            }
            
            
        }
    }
    public static void ApprovalSubMethod(Map<id,list<partner_role__c>> MapRoles,Partner_Role__c p,String fieldName)
    {
        Boolean SendApproval=False; 
        if( MapRoles.get(fieldName).size()==1)
        {
            if(p.Is_Approval__c==false && p.Status__c=='Pending approval' && (p.role__c=='Source'||(p.role__c=='Influence' && p.Has_Attachment__c==true)))
            {
               
                SendApproval=True;
            }
            //Assignment
        }
        else if(MapRoles.get(fieldName).size()>=2)
        {
            Boolean IssendApproval=false;
            Boolean Isupdateparent=false;
            Integer count=0;
            for(Partner_role__c roles:MapRoles.get(fieldName))
            {
                if(p.id!=roles.id && roles.Status__c=='Approved' && roles.Role__c=='Source' )
                {
                    if(p.role__c=='Source')
                    {
                        IssendApproval=True;
                    }
                }
                if(p.id!=roles.id && roles.Status__c=='Approved' )
                {
                    if(p.role__c!='Source')
                    {
                        Isupdateparent=True;
                    }
                }
                
            }
            
            if(p.Is_Approval__c==false && IssendApproval == false && ((p.Status__c=='Pending approval' &&p.role__c=='Influence' && p.Has_Attachment__c==true)||(p.Status__c=='Pending approval' &&p.role__c=='Source')))
            {
                SendApproval=True;
            }
        }
        if(SendApproval==True)
        {
            
            SendToApproval(p.id);
        }
    }
    public static void AssignmentMethod(Map<id,list<partner_role__c>> MapRoles,List<Partner_Role__c> RoleList,Map<id,partner_role__c> OldMapList)
    {
        
        UpdateLeads=new List<Lead>();
        UpdateOpps=new List<Opportunity>();
        for(Partner_Role__c p:RoleList)
        {
            
            if(String.isNotBlank(p.lead__c) && MapRoles.containskey(p.lead__c))
            {
                AssignmentSubMethod(MapRoles,p,p.lead__c);            
            }
            
            if(String.isNotBlank(p.Opportunity__c) && MapRoles.containskey(p.Opportunity__c))
            {
                AssignmentSubMethod(MapRoles,p,p.Opportunity__c);            
            }
            //Commented by Venkat for SFDC-386
            /*if(String.isNotBlank(p.Regional_PAM__c)&& p.Regional_PAM__c != OldMapList.get(p.Id).Regional_PAM__c&&p.Is_Approval__c==false)
            {
                SendToApproval(p.id);
            }*/
        }
        if(UpdateLeads!=null && UpdateLeads.size()>0)
        {
            try {
                Update UpdateLeads;
            } catch (Exception e) {
                ExceptionHandler.postToAll(e);
                throw new CustomException(ExceptionHandler.getBody(e));     
}
            
        }
        if(UpdateOpps!=null && UpdateOpps.size()>0)
        {
            try {
                Update UpdateOpps;
            } catch (Exception e) {
                ExceptionHandler.postToAll(e);
                throw new CustomException(ExceptionHandler.getBody(e));  
            }
            
            
        }
    }
    public static void AssignmentSubMethod(Map<id,list<partner_role__c>> MapRoles,Partner_Role__c p,String fieldName)
    {
        if( MapRoles.get(fieldName).size()==1)
        {
            
            if(p.Status__c=='Approved'&& p.Role__c=='Source')
            {
                if(String.isNotBlank(p.lead__c) && fieldName == p.Lead__c)
                {
                    //UpdateLeads.add(new lead(id=p.lead__c,rvpe__RVAccount__c=p.RV_Account__c,rvpe__RVMember__c=p.RV_Member__c,Commissions_Role__c=p.Commission_Role__c));   
                    UpdateLeads.add(new lead(id=p.lead__c,Partner_Company__c=p.Partner_Company__c,Partner_Contact__c=p.Partner_Contact__c,Commissions_Role__c=p.Commission_Role__c));   
                }
                if(String.isNotBlank(p.Opportunity__c) && fieldName == p.Opportunity__c)
                {
                    //UpdateOpps.add(new Opportunity(id=p.Opportunity__c,rvpe__RVAccount__c=p.RV_Account__c,rvpe__RVMember__c=p.RV_Member__c,Commission_Role__c=p.Commission_Role__c));
                    UpdateOpps.add(new Opportunity(id=p.Opportunity__c,Partner_Company__c=p.Partner_Company__c,Partner_Contact__c=p.Partner_Contact__c,Commission_Role__c=p.Commission_Role__c));   
                }
            }
            else if(p.Status__c=='Approved' && p.Role__c=='Influence')
            {
                if(String.isNotBlank(p.lead__c) && fieldName == p.Lead__c)
                {
                    //UpdateLeads.add(new lead(id=fieldName,rvpe__RVAccount__c=p.RV_Account__c)); 
                    UpdateLeads.add(new lead(id=fieldName,Partner_Company__c=p.Partner_Company__c)); 
                } 
                if(String.isNotBlank(p.Opportunity__c) && fieldName == p.Opportunity__c)
                {
                    //UpdateOpps.add(new Opportunity(id=p.Opportunity__c,rvpe__RVAccount__c=p.RV_Account__c)); 
                    UpdateOpps.add(new Opportunity(id=p.Opportunity__c,Partner_Company__c=p.Partner_Company__c)); 
                } 
            }
            
        }
        else if(MapRoles.get(fieldName).size()>=2)
        {
            Boolean Isupdateparent=false;
            for(Partner_role__c roles:MapRoles.get(fieldName))
            {
                if(p.id!=roles.id && roles.Status__c=='Approved' )
                {
                    if(p.role__c!='Source')
                    {
                        Isupdateparent=True;
                    }
                }
                
            }
            //Assignment
            
            if(Isupdateparent==false)
            {
                if(p.Status__c=='Approved' && p.Role__c=='Source')
                {
                    if(String.isNotBlank(p.lead__c) && fieldName == p.Lead__c)
                    {
                        //UpdateLeads.add(new lead(id=p.lead__c,rvpe__RVAccount__c=p.RV_Account__c,rvpe__RVMember__c=p.RV_Member__c,Commissions_Role__c=p.Commission_Role__c));   
                        UpdateLeads.add(new lead(id=p.lead__c,Partner_Company__c=p.Partner_Company__c,Partner_Contact__c=p.Partner_Contact__c,Commissions_Role__c=p.Commission_Role__c));   
                    }
                    if(String.isNotBlank(p.Opportunity__c) && fieldName == p.Opportunity__c)
                    {
                        //UpdateOpps.add(new Opportunity(id=p.Opportunity__c,rvpe__RVAccount__c=p.RV_Account__c,rvpe__RVMember__c=p.RV_Member__c,Commission_Role__c=p.Commission_Role__c));   
                        UpdateOpps.add(new Opportunity(id=p.Opportunity__c,Partner_Company__c=p.Partner_Company__c,Partner_Contact__c=p.Partner_Contact__c,Commission_Role__c=p.Commission_Role__c));   
                    } 
                }
                else if(p.Status__c=='Approved' && p.Role__c=='Influence')
                {
                    if(String.isNotBlank(p.lead__c) && fieldName == p.Lead__c)
                    {
                       // UpdateLeads.add(new lead(id=fieldName,rvpe__RVAccount__c=p.RV_Account__c)); 
                        UpdateLeads.add(new lead(id=fieldName,Partner_Company__c=p.Partner_Company__c)); 
                    } 
                    if(String.isNotBlank(p.Opportunity__c) && fieldName == p.Opportunity__c)
                    {
                       //UpdateOpps.add(new Opportunity(id=p.Opportunity__c,rvpe__RVAccount__c=p.RV_Account__c)); 
                        UpdateOpps.add(new Opportunity(id=p.Opportunity__c,Partner_Company__c=p.Partner_Company__c)); 
                    }    
                }
            }                            
        }
    }
    //Send Approval Method
    public static void SendToApproval(Id recordID)
    {
        if(!Approval.isLocked(recordID))
        { 
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(recordID);
        // submit the approval request for processing
        Approval.ProcessResult result = Approval.process(req);
        // display if the reqeust was successful
        System.debug('Submitted for approval successfully: '+result.isSuccess());
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    //collection of Lead ids
    public static Set<Id> setLeadIds {
        get{
            if(setLeadIds == null) {
                setLeadIds = new Set<Id>();
                for(Partner_Role__c pr : (List<Partner_Role__c>)Trigger.new) {
                    if(String.isNotBlank(pr.lead__c)) {
                        setLeadIds.add(pr.lead__c);
                    }                   
                }
            }
            return setLeadIds;          
        }
        set;
    }
    
    //collection of Opportunity ids
    public static Set<Id> setOpportunityIds {
        get{
            if(setOpportunityIds == null) {
                setOpportunityIds = new Set<Id>();
                for(Partner_Role__c pr : (List<Partner_Role__c>)Trigger.new) {
                    if(String.isNotBlank(pr.Opportunity__c)) {
                        setOpportunityIds.add(pr.Opportunity__c);
                    }                   
                }
            }
            return setOpportunityIds;           
        }
        set;
    }
    
    //set role statuses
    public static void setRoleStatus(List<Partner_Role__c> triggerNew, Map<Id, Partner_Role__c> triggerOldMap) {
        //////////////////////////////////////////////////////////////////////////////////////////////////
        // @developer   :    Diego Castro
        // @date        :    09/10/2017
        // @story       :    SFDC-369, defect
        // @description :    Prevents method from executing if User is Foundation/API user.
        //////////////////////////////////////////////////////////////////////////////////////////////////
        if(!userinfo.getuserid().contains(Label.FMWFoundationUser) && !userinfo.getuserid().contains(Label.FMW_API_User)) {
            ///////////////////////////////////////end SFDC-369///////////////////////////////////////////////                    
            for(Partner_Role__c pr : triggerNew) {
                if(triggerOldMap == null){
                    if(pr.Role__c == 'Source' && pr.Justification__c != 'Partner Portal') {
                        pr.Status__c = 'Pending Approval';
                    }
                    else if(pr.Role__c == 'Influence') {
                        pr.Status__c = 'New';
                    }
                }
                else {
                    if(pr.Role__c == 'Source' && triggerOldMap.get(pr.Id).Role__c != 'Source') {
                        pr.Status__c = 'Pending Approval';
                    }
                    else if(triggerOldMap.get(pr.Id).Role__c != 'Influence' && pr.Role__c == 'Influence') {
                        pr.Status__c = 'New';
                    }
                }
            }
        }
    }
    
    //map approved roles
    public static Map<Id, List<Partner_Role__c>> mapApprovedRoles {
        get{
            if(mapApprovedRoles == null) {
                mapApprovedRoles = new Map<Id, List<Partner_Role__c>>();
                //List of all approved records
                List<Partner_Role__c> lstRoles = [SELECT Id, Lead__c, Role__c, Status__c, Opportunity__c, Has_Attachment__c 
                                                  FROM Partner_Role__c WHERE (Lead__c IN :setLeadIds OR Opportunity__c IN :setOpportunityIds) AND Status__c = 'Approved'];
                if(lstRoles.size() > 0) {
                    //Helper class method returns a map which have approved roles list under a Lead/Opportunity
                    mapApprovedRoles = PartnerRoleTriggerHelper.mapValues(lstRoles);
                }
            }
            return mapApprovedRoles;
        }
        set;
    }
    
    //map roles
    public static Map<Id, List<Partner_Role__c>> mapRoles {
        get{
            if(mapRoles == null) {
                mapRoles = new Map<Id, List<Partner_Role__c>>();
                List<Partner_Role__c> lstRoles = [SELECT Id, Lead__c, Role__c, Status__c, Opportunity__c, Has_Attachment__c 
                                                  FROM Partner_Role__c WHERE (Lead__c IN :setLeadIds OR Opportunity__c IN :setOpportunityIds) AND Status__c != 'Rejected'];
                if(lstRoles.size() > 0) {
                    //Helper class method returns a map which have approved/pending approval roles list under a Lead/Opportunity
                    mapRoles = PartnerRoleTriggerHelper.mapValues(lstRoles);
                }
            }
            return mapRoles;
        }
        set;
    }
    Public static void AutoApproval(List<Partner_Role__c> ListUnlockRecords)
    {
       Map<ID,String> mapApprovals=New Map<ID,String>();
       for(Partner_Role__c Role: ListUnlockRecords)
        {
            if(Role.Status__c=='Approved')
            {
                //RoleApproved.add(Role.id);
                mapApprovals.put(Role.id,'Approve');
            }
            else if(Role.Status__c=='Rejected')
            {
                mapApprovals.put(Role.id,'Reject');
            }
        
        }
        if(mapApprovals.size()>0)
        {
          ApprovalHelper.ApproveRecords(mapApprovals, 'Approved/Rejected from other system' );
        }
       
    }
    
}