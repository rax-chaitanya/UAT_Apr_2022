global class sendRemainderMailSchedular implements Schedulable {
    
    
    global void execute(SchedulableContext SC) {
        SendReminderMail sr= new SendReminderMail();
        
            Database.executeBatch(sr, 2000);
    }

}