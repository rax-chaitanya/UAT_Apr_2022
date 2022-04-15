global class CascadeTeamMemberBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CascadeTeamMemberBatch());
    } 
    
    
}