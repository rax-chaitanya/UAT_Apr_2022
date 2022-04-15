/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////									EditFocusAreasController									/////
/////		Written By: Diego Castro									Language: Apex				/////
/////		Environment: Dev Console									Date: 10/14/2016			/////
/////																								/////
/////		Description: Controller for the Edit Focus Areas Visualforce Page.						/////
/////		Will only allow end user to save if focus area percentages under an opportunity			/////
/////		equal 100%.																				/////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////										Change Log												/////
/////		Developer:													Date Updated:				/////
/////																								/////
/////		Description:																			/////
/////																								/////
/////////////////////////////////////////////////////////////////////////////////////////////////////////


public class EditFocusAreasController extends Framework {
    public List<Opp_FocusArea__c> focusAreas {get; set;}
    public String userClicked {get; set;}
    public String opportunityId {get; set;}

    public Decimal per {get; set;}
        
    
	//standard controller used because
	// (1) page was built using generic vf framework -- focus_area_percentage__c and focus_area_debook__c are input fields 
	// 		which means the user profile needs both field level security enabled and the ability to read and edit the sObject
	// (2) when edit permissions are enabled for a profile, the related list for an sObject will have an 'Edit' button enabled and in order
	// 		to prevent the end users from editing individual focus areas, the edit button needed to be overridden with a custom button
	// (3) the edit button in the related list could only be overriden with standard controller 				    

    public EditFocusAreasController (ApexPages.StandardController std) {
        super('EditFocusAreas');        
        
        Id objId = ApexPages.currentPage().getParameters().get('id');
        
        if (String.isNotBlank(objId)) {            											//user clicked edit from opporunity related list action edit btn

            queryBuilder.setSObject(new Opp_FocusArea__c(ID = objId));			            //associate an sObject with the queryBuilder in order to determine which filters are to be used
            
            String query = queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('EFA-2').Query_Id__c);    
            
            Opp_FocusArea__c ofa = Database.query(query);
            
            opportunityId = ofa.Opportunity__c;
            
        } else {
            opportunityId = ApexPages.currentPage().getParameters().get('oid');             //user clicked related list button to edit focus areas
        }
        queryBuilder.setsObject(null);
        focusAreas = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('EFA-1').Query_Id__c));
        if (focusAreas.size() > 0) {
            calculate();
        } else {
            ApexPages.addMessage(new apexPages.Message(ApexPages.Severity.Error, 'No focus areas found for this opportunity.'));
        }
        
    }
    
    //will run when and end user types into any percentage input field -- determines sum of all percentages and will complain if not equal to 100
    public PageReference calculate() {
        per = 0;
        for (Opp_FocusArea__c fa : focusAreas) {
            if (fa.Focus_Area_Percentage__c == null) {
                return null;
            }
            if (String.isNotBlank(fa.Focus_Area_Percentage__c.format()) && Integer.valueOf(fa.Focus_Area_Percentage__c) > 0) {
                per += fa.Focus_Area_Percentage__c;
            } else {
                ApexPages.addMessage(new apexPages.Message(ApexPages.Severity.Error, 'Focus Area Percentage must be greater than 0'));
                return null;   
            }
        } 
        
        if (per != 100) {
            ApexPages.addMessage(new apexPages.Message(ApexPages.Severity.Error, 'The TOTAL Focus Area Percentage must equal 100%.'));
            return null;
        } else {
            ApexPages.addMessage(new apexPages.Message(ApexPages.Severity.CONFIRM, 'The total focus area percentage equals 100%.'));
            if (userClicked == 'save') {
                try {
                    update focusAreas;
                    return back();
                } catch (Exception e) {
                    ApexPages.addMessage(new apexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }
        }
        return null;
    }
    
    //called via action method since calling via action function refreshes messages and won't redirect
    // if used on save method, it would not redirect back to opportunity
    public PageReference saveFAs() {
        userClicked = 'save';
        return calculate();
    }
    
    public PageReference back() {
        PageReference p = new PageReference('/' + opportunityId);
        p.setRedirect(true);
        return p;
    }
}