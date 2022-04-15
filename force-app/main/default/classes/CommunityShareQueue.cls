public without sharing class CommunityShareQueue implements Queueable{
    
    public List<sObject> shareRecords;
    public boolean isShare;
    public List<AccountTeamMember> accTeams;
    public List<User> users;
    List<OpportunityTeamMember> oppTeams;
    public CommunityShareQueue(List<sObject> shares,boolean isShare){
        this.shareRecords = shares;
        this.isShare = isShare;
    }
    
    public CommunityShareQueue(List<sObject> shares,List<AccountTeamMember> accTeams,boolean isShare){
        this.shareRecords = shares;
        this.isShare = isShare;
        this.accTeams = accTeams;
    }
    
    public CommunityShareQueue(List<sObject> shares,List<AccountTeamMember> accTeams,List<OpportunityTeamMember> oppTeams,boolean isShare){
        this.shareRecords = shares;
        this.isShare = isShare;
        this.accTeams = accTeams;
        this.OppTeams = oppTeams;
    }
    public CommunityShareQueue(List<AccountTeamMember> accTeams,boolean isShare){
        this.accTeams = accTeams;
        this.isShare = isShare;
    }
    
    public CommunityShareQueue(List<User> users){
        this.users = users;
        
    }
    public void execute(QueueableContext qc){
       
                if(shareRecords != null && !shareRecords.isEmpty()){
            if(isShare)
                Database.insert(shareRecords,false);
            else delete shareRecords;
        }
        
        if(accTeams != null && !accTeams.isEmpty()){
            
            if(isShare)
               Database.insert(accTeams,false);
            else
                delete accTeams;
        }
        
        if(oppTeams != null && !oppTeams.isEmpty()){
            
            if(isShare)
                 Database.insert(oppTeams,false);
            else
                delete oppTeams;
        }
        try{
            if(users != null && !users.isEmpty())
            update users;
        }catch(Exception ex){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
            mail.setSenderDisplayName('Rackspace Network');
            mail.setSubject('Partner Staus');
            mail.setPlainTextBody('Hi, Could not activate the partner : '+ex.getMessage());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}