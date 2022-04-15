global class AccountUpdateBatchJobscheduled implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        AccountUpdateBatchJob b = new AccountUpdateBatchJob(); 
        database.executebatch(b,20);
    }
}