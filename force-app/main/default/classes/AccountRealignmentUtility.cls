/**********************************************************************************

Author: Omkar Narkar
Description: This utility apex class is created for the Global Account Realignment. Epic : SFDC-2278.

**********************************************************************************/
public class AccountRealignmentUtility {
    
    private static final Set<String> lookupTypes = new Set<String>{'Account', 'LoggedInUser', 'NewOwner'};
        private static final Set<String> functionTypes = new Set<String>{'isOwnerReportee', 'isCrossRegionGroupTeam', 'getNewOwnerSegment', 'isValidBusinessManager'};

            
            public static List<Realignment_Request_Item__c> process(List<Realignment_Request_Item__c> requestItems){
                Set<Id> userIds = new Set<Id>();
                Set<Id> accountIds = new Set<Id>();
                for(Realignment_Request_Item__c requestItem : requestItems){
                    userIds.add(requestItem.New_Account_Owner__c);
                    accountIds.add(requestItem.Account__c);
                }
                
                Map<String, List<Realignment_Request_Item__c>> requestMap = new Map<String, List<Realignment_Request_Item__c>>();
                Map<String, Map<String, String>> approvarDetailMap = new Map<String, Map<String, String>>();
                for(Realignment_Request_Item__c requestItem : requestItems){
            Map<String, String> approver = processItem(requestItem, userIds, accountIds);
                    
                    requestItem.Validation_Comments__c = approver.get('Rule');
                    if(!requestMap.containsKey(approver.get('Id'))){
                        requestMap.put(approver.get('Id'), new List<Realignment_Request_Item__c>());
                    }
                    requestMap.get(approver.get('Id')).add(requestItem);
                    approvarDetailMap.put(approver.get('Id'), approver);
                }
                
                return performDML(requestMap, approvarDetailMap);
            }
    
    private static List<Realignment_Request_Item__c> performDML(Map<String, List<Realignment_Request_Item__c>> requestMap, Map<String, Map<String, String>> approvarDetailMap){
        Map<String, Account_Realignment_Request__c> requests = new Map<String, Account_Realignment_Request__c>();
        List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
        
        for(String approver : requestMap.keySet()){
            requests.put(
                //Key
                approver,
                //Value
                new Account_Realignment_Request__c(
                    Approver__c = approver == null ? Userinfo.getUserId() : approver,
                    Status__c = 'New',
                    Submitted_date__c =Date.Today(),
                    Approver_Type__c = approvarDetailMap.get(approver).get('Type'),
                    Region__c = approvarDetailMap.get(approver).get('Region')
                ));
        }
        Database.insert(requests.values());
        system.debug('acc values'+requests.values() );
        
        for(String approver: requestMap.keySet()){
            for(Realignment_Request_Item__c item : requestMap.get(approver)){
                item.Account_Realignment_Request__c = requests.get(approver).Id;
                //item.Validation_Comments__c = approvarDetailMap.get(approver).get('Rule');
                item.Submitter__c = UserInfo.getUserId();
                item.Submitted_date__c = Date.Today();
                requestItems.add(item);
            }
        }
        Database.insert(requestItems);
        
        Map<Id, Boolean> requestsApprovalResult = invokeApprovalProcess(requests.values());
        system.debug('requestsApprovalResult'+ requestsApprovalResult);
        Map<Id, Boolean> itemApprovalResult = invokeApprovalProcess(requestItems);
        system.debug('itemApprovalResult'+ itemApprovalResult);
        return [SELECT Account__c, Account__r.Name, Account_Realignment_Request__c, Account_Realignment_Request__r.Approver__c, Account_Realignment_Request__r.Approver__r.Name, Account_Realignment_Request__r.Approver_Formula__c, Submitter__c, Submitter__r.Name, Submitted_date__c, Previous_Account_Owner__c, Previous_Account_Owner__r.Name, New_Account_Owner__c, New_Account_Owner__r.Name, Request_Status__c, Reason_for_Move__c, Approver_Comments__c, Validation_Comments__c, Reason_for_Overriding_Validation_Comment__c, Move_Date__c, Processed__c, Approved__c, Id, Name FROM Realignment_Request_Item__c WHERE Id IN:requestItems];
    }
    
    public static Map<Id, Boolean> invokeApprovalProcess(List<sObject> records){
        Map <Id, Boolean> result = new Map<Id, Boolean>();
        List<Approval.ProcessSubmitRequest> approvalRequests = new List<Approval.ProcessSubmitRequest>();
       
        for(sObject record : records){
              
            // Create an approval request for the account
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setObjectId((Id)record.get('Id'));
            system.debug('object Id' + (Id)record.get('Id') );
            // Submit on behalf of a specific submitter
        request.setSubmitterId(UserInfo.getUserId());
            approvalRequests.add(request);
        }
        
        // Submit the approval request for the account
        for(Approval.ProcessResult approvalResult : Approval.process(approvalRequests, false)){
            result.put(approvalResult.getEntityId(), approvalResult.isSuccess());
            system.debug('approvalResult' +approvalResult);
            system.debug('approvalResult.getEntityId()' +approvalResult.getEntityId());
            
            system.debug('approvalResult' +approvalResult);
           
        }
        
        // Verify the result
        return result;
    }
    
    
    private static Map<String, String> processItem(Realignment_Request_Item__c item, Set<Id> userIds, Set<Id> accountIds){
        
        User loggedInUser = getLoggedInUser();
        User newOwner = getUserDetails(userIds).get(item.New_Account_Owner__c);
        Account account = getAccountDetails(accountIds).get(item.Account__c);
        Map<String, String> approver = new Map<String, String>();
        approver.put('Type', 'Self');
        String ownerRegion = account.Owner.Region__c == null ? 'AMER' : account.Owner.Region__c;
        approver.put('Region', ownerRegion);
        
        //Checking if Valid Business Manager
        List<String> businessManagers = getBusinessManagers(account);
        if(businessManagers.contains(UserInfo.getUserId())){
            approver.put('Rule', 'Auto Approved');
            return approver;
        }
        
         //SFDC-7321 - GART Tool Validation when Previous owner and New owner matches - Starts - Rishabh - 10/03/2022
        if(newOwner.Id == account.OwnerId){
            approver.put('Rule', 'Auto Approved');
            return approver;
        }
        //SFDC-7321 - GART Tool Validation when Previous owner and New owner matches - Ends - Rishabh - 10/03/2022
        
           //SFDC - 4076
        //check if new account owner region is EMEA and Role type is Q Team
        if(newOwner.Region__c == 'EMEA' && newOwner.Role_Type__c == 'Q Team' )
        {
            approver.put('Rule', 'Auto Approved');
            return approver;
        }
        
        for(Account_Realignment_Rule__mdt rule : getRules()){
            Boolean result;
            approver.put('Rule', rule.Validation_Description__c);
            for(Acceptance_Criteria__mdt criteria : rule.Acceptance_Criterion__r){
                String expr1 = getExpressionValue(criteria, 'Expression1', loggedInUser, newOwner, account, userIds, accountIds);
                String expr2 = getExpressionValue(criteria, 'Expression2', loggedInUser, newOwner, account, userIds, accountIds);
                String comparator = criteria.Comparator__c;
                Boolean comparisionResult = getComparisonResult(expr1, comparator, expr2);
                if(result == null){
                    result = comparisionResult;
                }
                else if(rule.Logic__c == 'OR'){
                    result = result || comparisionResult;
                }
                else if(rule.Logic__c == 'AND'){
                    result = result && comparisionResult;
                }
            }
            
            if(result && rule.Auto_Approve__c){
                //Found matching rule for auto approval
                return approver;
            }
            else if(result && !rule.Auto_Approve__c){
                //Found matching rule for Manager or Business Manager
                if(rule.Approver__c.equalsIgnoreCase('Manager') && account.Owner!=null && account.Owner.ManagerId != null && account.Owner.Manager.IsActive){
                    approver.put('Id', account.Owner.ManagerId);
                    approver.put('Type', 'Manager');
                }
                if(rule.Approver__c.equalsIgnoreCase('Business Manager') || approver.get('Id') == null){
                    if(businessManagers!=null){
                        approver.put('Id', businessManagers[0]);
                    }
                    approver.put('Type', 'Business Manager');
                }
                return approver;
            }
        }
        
        //If no approver is found then request will be auto approved
        approver.put('Rule', 'Auto approved.');
        return approver;
    }
    
    private static Map<String, List<String>> businessManagerMap;
    public static List<String> getBusinessManagers(Account account){
        String ownerRegion = account.Owner.Region__c == null ? 'AMER' : account.Owner.Region__c;
        if(businessManagerMap != null){
            return businessManagerMap.get(ownerRegion);
        }
        businessManagerMap = new Map<String, List<String>>();
        Map<String, Set<String>> regionQueueMap = new Map<String, Set<String>>();
        for(GAR_Business_Manager__mdt businessManagerGroup : [SELECT DeveloperName, MasterLabel, Queue_Name__c FROM GAR_Business_Manager__mdt]){
            if(!regionQueueMap.containsKey(businessManagerGroup.Queue_Name__c)){
                regionQueueMap.put(businessManagerGroup.Queue_Name__c, new Set<String>());
            }
            regionQueueMap.get(businessManagerGroup.Queue_Name__c).add(businessManagerGroup.DeveloperName);
        }
        for(Group businessManagerGroup : [SELECT Id, DeveloperName, Type, (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE DeveloperName IN: regionQueueMap.keySet()]){
            List<String> members = new List<String>();
            for(GroupMember member : businessManagerGroup.GroupMembers){
                members.add(member.UserOrGroupId);
            }
            if(regionQueueMap.containsKey(businessManagerGroup.DeveloperName)){
                for(String region : regionQueueMap.get(businessManagerGroup.DeveloperName)){
                    businessManagerMap.put(region,  members);
                }
            }
        }
        
        return businessManagerMap.get(ownerRegion);
    }
    
    private static boolean getComparisonResult(String expr1, String comparator, String expr2){
        if(comparator == 'EQUALS' && expr1 == expr2){
            return true;
        }
        if(comparator == 'NOT EQUALS' && expr1 != expr2){
            return true;
        }
        if(comparator == 'CONTAINS'){
            expr1 = ''+expr1;
            return expr1.containsIgnoreCase(expr2);
        }
        if(comparator == 'LESS THAN' && Decimal.valueOf(expr1) < Decimal.valueOf(expr2)){
            return true;
        }
        if(comparator == 'GREATER THAN' && Decimal.valueOf(expr1) > Decimal.valueOf(expr2)){
            return true;
        }
        return false;
    }
    
    private static String getExpressionValue(Acceptance_Criteria__mdt criteria, String expr, User loggedInUser, User newOwner, Account account, Set<Id> userIds, Set<Id> accountIds){
        String result;
        if(lookupTypes.contains((String)criteria.get(expr+'_Type__c'))){
            result = getLookupExpressionValue(
                String.valueOf(criteria.get(expr+'_Type__c')),
                String.valueOf(criteria.get(expr+'_Field_Name__c')),
                String.valueOf(criteria.get(expr+'_Relationship_Name__c')),
                loggedInUser,
                newOwner,
                account
            );
        }
        else if(((String)criteria.get(expr+'_Type__c')) == 'Function' && functionTypes.contains((String)criteria.get(expr+'_Value__c'))){
            result = getFunctionExpressionValue((String)criteria.get(expr+'_Value__c'), loggedInUser, newOwner, account, userIds, accountIds);
        }
        else{
            result = String.valueOf(criteria.get(expr+'_Value__c'));
        }
        return result;
    }
    
    private static String getLookupExpressionValue(String type, String fieldName, String relationshipName, User loggedInUser, User newOwner, Account account){
        String result;
        sObject relatedObject = account;
        if(type == 'Account'){
            relatedObject = account;
        }
        else if(type == 'LoggedInUser'){
            relatedObject = loggedInUser;
        }
        else if(type == 'NewOwner'){
            relatedObject = newOwner;
        }
        
        if(!String.isEmpty(relationshipName)){
            List<String> relation = relationshipName.contains('.') ?  relationshipName.split('\\.') : new List<String>{relationshipName};
            for(String relationship : relation){
                if(relatedObject == null){
                    return null;
                }
                relatedObject = relatedObject.getSObject(relationship);
            }
        }
        result = relatedObject !=null ? String.valueOf(relatedObject.get(fieldName)) : null;
        return result;
    }
    
    private static String getFunctionExpressionValue(String function, User loggedInUser, User newOwner, Account account, Set<Id> userIds, Set<Id> accountIds){
        if(function == 'isOwnerReportee' && isOwnerReportee(account)){
            return 'True';
        }
        if(function == 'isCrossRegionGroupTeam' && isCrossRegionGroupTeam(newOwner, account, accountIds)){
            return 'True';
        }
        if(function == 'getNewOwnerSegment'){
            return getNewOwnerSegment(newOwner);
        }
        if(function == 'isValidBusinessManager' && isValidBusinessManager(account)){
            return 'True';
        }
        return 'False';
    }
    
    private static Boolean isCrossRegionGroupTeam(User newOwner, Account account, Set<Id> accountIds){
        if(!isTeamMember(newOwner, account, accountIds) || account.Owner.Group__c != newOwner.Group__c || account.Owner.Region__c != newOwner.Region__c){
            return true;
        }
        return false;
    }
    private static Boolean isValidBusinessManager(Account account){
        List<String> businessManagers = getBusinessManagers(account);
        if(businessManagers!=null){
            return businessManagers.contains(UserInfo.getUserId());
        }
        return false;
    }
    
    private static Map <Id, String> userSegmentMap;
    private static String getNewOwnerSegment(User newOwner){
        if(userSegmentMap!=null){
            return userSegmentMap.containsKey(newOwner.Id) ? userSegmentMap.get(newOwner.Id) : null;
        }
        return getRoleBasedSegmentation(newOwner.UserRole.Name);
        
    }
    
    private Static Map<String, String> roleBasedSegmentationMap;
    private static String getRoleBasedSegmentation(String userRole){
        if(roleBasedSegmentationMap!=null){
            return roleBasedSegmentationMap.get(userRole);
        }
        roleBasedSegmentationMap = new Map<String, String>();
        for(Role_Based_Revenue_Segmentation__mdt segment : [SELECT User_Role__c, Segment__c FROM Role_Based_Revenue_Segmentation__mdt]){
            roleBasedSegmentationMap.put(segment.User_Role__c, segment.Segment__c);
        }
        return roleBasedSegmentationMap.get(userRole);
    }
    
    private static set<Id> reportees;
    private static Boolean isOwnerReportee(Account account){
        if(reportees!=null){
            return reportees.contains(account.OwnerId);
        }
        Map<Id, User> reporteeMap = new Map<Id, User>([SELECT Id FROM User WHERE ManagerId =: Userinfo.getUserId()]);
        reportees = new Set<Id>();
        reportees.addAll(reporteeMap.keySet());
        do {
            reporteeMap = new Map<Id, User>([SELECT Id FROM User WHERE ManagerId IN: reportees AND Id NOT IN: reportees]);
            reportees.addAll(reporteeMap.keySet());
        }
        while(!reporteeMap.isEmpty());
        return reportees.contains(account.OwnerId);
    }
    
    private static Map<Id, Set<Id>> teamMembers;
    private static Boolean isTeamMember(User newOwner, Account account, Set<Id> accountIds){
        if(teamMembers!=null){
            return teamMembers.get(account.Company_Name__c).contains(newOwner.Id);
        }
        teamMembers = new Map<Id, Set<Id>>();
        Map<Id, Account> accountDetails = getAccountDetails(accountIds);
        for(Account acc : accountDetails.values()){
            teamMembers.put(acc.Company_Name__c, new Set<Id>());
        }
        for(AccountTeamMember member : [SELECT AccountId, UserId FROM AccountTeamMember WHERE AccountId IN: teamMembers.keySet()]){
            teamMembers.get(member.AccountId).add(member.UserId);
        }
        return teamMembers.get(account.Company_Name__c).contains(newOwner.Id);
    }
    
    private static List<Account_Realignment_Rule__mdt> rules;
    private static List<Account_Realignment_Rule__mdt> getRules(){
        if(rules!=null){
            return rules;
        }
        rules = [SELECT Id, Sort_Order__c, Logic__c, Auto_Approve__c, Approver__c, Validation_Description__c,
                 (SELECT Id, 
                  Account_Realignment_Rule__c, 
                  Expression1_Type__c, 
                  Comparator__c, 
                  Expression1_Value__c, 
                  Expression1_Relationship_Name__c, 
                  Expression2_Field_Name__c, 
                  Expression1_Field_Name__c, 
                  Expression2_Relationship_Name__c, 
                  Expression2_Type__c, 
                  Expression2_Value__c 
                  FROM Acceptance_Criterion__r)
                 FROM Account_Realignment_Rule__mdt
                 ORDER BY Sort_Order__c
                ];
        return rules;
    }
    
    private static User loggedInUser;
    private static User getLoggedInUser(){
        if(loggedInUser!=null){
            return loggedInUser;
        }
        
        Id loggedInUserId = UserInfo.getUserId();
        Set<String> userFields = new Set<String>();
        List<Account_Realignment_Rule__mdt> rules = getRules();
        for(Account_Realignment_Rule__mdt rule : rules){
            for(Acceptance_Criteria__mdt criteria : rule.Acceptance_Criterion__r){
                if(criteria.Expression1_Type__c == 'LoggedInUser'){
                    String field = String.isBlank(criteria.Expression1_Relationship_Name__c) ? criteria.Expression1_Field_Name__c : criteria.Expression1_Relationship_Name__c+'.'+criteria.Expression1_Field_Name__c;
                    userFields.add(field);
                }
                if(criteria.Expression2_Type__c == 'LoggedInUser'){
                    String field = String.isBlank(criteria.Expression2_Relationship_Name__c) ? criteria.Expression2_Field_Name__c : criteria.Expression2_Relationship_Name__c+'.'+criteria.Expression2_Field_Name__c;
                    userFields.add(field);
                }
            }
        }
        String query = 'SELECT CreatedDate';
        for(String field : userFields){
            query += ', '+field;
        }
        query += ' FROM User WHERE Id =:loggedInUserId';
        
        loggedInUser = (User)Database.query(query);
        return loggedInUser;
    }
    
    private static Map<Id, User> userDetails;
    private static Map<Id, User> getUserDetails(Set<Id> userIds){
        if(userDetails!=null){
            return userDetails;
        }
        
        Set<String> userFields = new Set<String>();
        List<Account_Realignment_Rule__mdt> rules = getRules();
        for(Account_Realignment_Rule__mdt rule : rules){
            for(Acceptance_Criteria__mdt criteria : rule.Acceptance_Criterion__r){
                if(criteria.Expression1_Type__c == 'NewOwner'){
                    String field = String.isBlank(criteria.Expression1_Relationship_Name__c) ? criteria.Expression1_Field_Name__c : criteria.Expression1_Relationship_Name__c+'.'+criteria.Expression1_Field_Name__c;
                    userFields.add(field);
                }
                if(criteria.Expression2_Type__c == 'NewOwner'){
                    String field = String.isBlank(criteria.Expression2_Relationship_Name__c) ? criteria.Expression2_Field_Name__c : criteria.Expression2_Relationship_Name__c+'.'+criteria.Expression2_Field_Name__c;
                    userFields.add(field);
                }
            }
        }
        String query = 'SELECT CreatedDate';
        for(String field : userFields){
            query += ', '+field;
        }
        query += ' FROM User WHERE Id IN:userIds';
        userDetails = new Map<Id, User>((List<User>)Database.query(query));
        return userDetails;
    }
    
    private static Map<Id, Account> accountDetails;
    private static Map<Id, Account> getAccountDetails(Set<Id> accountIds){
        if(accountDetails!=null){
            return accountDetails;
        }
        Set<String> accountFields = new Set<String>();
        List<Account_Realignment_Rule__mdt> rules = getRules();
        for(Account_Realignment_Rule__mdt rule : rules){
            for(Acceptance_Criteria__mdt criteria : rule.Acceptance_Criterion__r){
                if(criteria.Expression1_Type__c == 'Account'){
                    String field = String.isBlank(criteria.Expression1_Relationship_Name__c) ? criteria.Expression1_Field_Name__c : criteria.Expression1_Relationship_Name__c+'.'+criteria.Expression1_Field_Name__c;
                    accountFields.add(field);
                }
                if(criteria.Expression2_Type__c == 'Account'){
                    String field = String.isBlank(criteria.Expression2_Relationship_Name__c) ? criteria.Expression2_Field_Name__c : criteria.Expression2_Relationship_Name__c+'.'+criteria.Expression2_Field_Name__c;
                    accountFields.add(field);
                }
            }
        }
        String query = 'SELECT Owner.ManagerId, Owner.Manager.IsActive ';
        for(String field : accountFields){
            query += ', '+field;
        }
        query += ' FROM Account WHERE Id IN:accountIds';
        system.debug('Query '+ query);
        accountDetails = new Map<Id, Account>((List<Account>)Database.query(query));
      return accountDetails;
    }
    
    public static Boolean canProcessRealignmentRequests(){
        Integer businessDayCount = CalendarUtility.getBusinessDayCount();
        return businessDayCount > 5;
    }
}