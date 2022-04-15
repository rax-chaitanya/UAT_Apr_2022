global class scheduleQueue implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Time start = Time.newInstance(8,0,0,0);
        Time stop = Time.newInstance(17,0,0,0);
    
        datetime myDateTime = datetime.now();
        myDateTime -= (6/24); 
        Time CstTime = myDateTime.time();
        
        List<GroupMember> memList1 = new List<GroupMember>();
        List<Id> userIds = new List<Id>();
    
        String gts = Label.GTS_High;
        String temp = Label.LATAM_Queue;
        List<String> latam = temp.split(',');
        
        Id GTSid = [Select Id,developerName from Group where type= 'queue' AND developername =: gts].id;
        
        Map<Id,Group> Qlist2 = new Map<Id,Group>([Select Id,DeveloperName from Group where type= 'queue' AND developername in: latam]);

         
        memList1 = [Select UserOrGroupId from GroupMember where GroupId =: GTSid ];
        
        for(GroupMember g: memList1){
            userIds.add(g.UserOrGroupId);
        }
     
        if(CstTime >= start && CstTime < stop){
        //Remove UserIds users from new queue

            List<GroupMember> newList = new List<GroupMember>();            
            newList = [select Id from GroupMember where GroupId in: Qlist2.keyset() AND UserOrGroupId in: userIds];
            Database.delete(newList,false);
        }
        
        if(CstTime >= stop){       
        //Add userIds users to new queue
            List<GroupMember> newList = new List<GroupMember>();
            
                for(Id i:userIds){
                    for(Id i2:Qlist2.keyset()){
                        GroupMember gm = new GroupMember();
                        gm.UserOrGroupId = i;
                        gm.GroupId = i2;
                        newList.add(gm);
                    }
                }
            
        Database.Insert(newList,false);
        }
        
    }
}