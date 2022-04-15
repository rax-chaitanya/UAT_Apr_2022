/**
* Created by  : Venkat
* Created Date: 20/01/2017
* Description: It helps to Approve or Reject dynamically
*  
* */
public class ApprovalHelper{

  public static void ApproveRecords(Map<ID,String> RecordIds, String Comments )
  {
        
       List<ProcessInstanceWorkitem> workItems = [ SELECT Id, ProcessInstanceId,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :RecordIds.KeySet() and  ProcessInstance.Status = 'Pending' ];
       List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
       
       for(ProcessInstanceWorkitem workItem : workItems)
       {
           Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
           req.setWorkitemId(workItem.Id);
           //Valid values are: Approve, Reject, or Removed. 
           //Only system administrators can specify Removed.
           req.setAction(RecordIds.get(workItem.ProcessInstance.TargetObjectId));
           req.setComments(Comments);
           requests.add(req);
       }
       try 
       {
           // Execute process request
           Approval.ProcessResult[] processResults = Approval.process(requests);
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e)); 
        }
  }
}