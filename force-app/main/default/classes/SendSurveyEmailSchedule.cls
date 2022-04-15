Global Class SendSurveyEmailSchedule implements Schedulable
{
    /*
        Note: Execute the below Survey Schedule CRON code in Anonymous Window 
    
        SendSurveyEmailSchedule firstTUE = new SendSurveyEmailSchedule();
        String sched1 = '0 0 6 ? 1/1 TUE#1 *';
        System.schedule('JobOn1stTuesday',sched1,firstTUE);
        
        SendSurveyEmailSchedule firstTHU = new SendSurveyEmailSchedule();
        String sched2 = '0 0 6 ? 1/1 THU#1 *';
        System.schedule('JobOn1stThursday',sched2,firstTHU);
        
        SendSurveyEmailSchedule secondTUE = new SendSurveyEmailSchedule();
        String sched3 = '0 0 6 ? 1/1 TUE#2 *';
        System.schedule('JobOn2ndTuesday',sched3,secondTUE);
        
        SendSurveyEmailSchedule secondTHU = new SendSurveyEmailSchedule();
        String sched4 = '0 0 6 ? 1/1 THU#2 *';
        System.schedule('JobOn2ndThursday',sched4,secondTHU);                
    */
    
    Public void Execute(Schedulablecontext sc){        
        List<OPCPilotUser__c> opcpilotuserlist = [select id,name,isactive__c from OPCPilotUser__c where isactive__c=True];
        Set<string> userlist=new Set<string>();
        for(OPCPilotUser__c opc:opcpilotuserlist){
            userlist.add(opc.name);
            System.debug('userlist:' + userlist.size()); 
        }
        SendSurveyEmailBatch send = New SendSurveyEmailBatch(userlist);
        Database.executebatch(send,2000);
    }
}