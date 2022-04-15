global class QLDeleteOppIDBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new QLDeleteOppIDBatch());
    } 
    

}