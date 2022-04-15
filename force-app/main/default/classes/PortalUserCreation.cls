public class PortalUserCreation implements Queueable {
    public List<User> partnerUsers;
    
    public PortalUserCreation(List<User> listUsers){
        this.partnerUsers=listUsers;
    }
    public void execute(QueueableContext context) {
        try{ 
            insert partnerUsers;
        }catch(Exception ex){
            sendExceptionMail(ex.getMessage());
        }
        
        
    }
    public static void sendExceptionMail(String msg){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
        mail.setSenderDisplayName('Rackspace Network');
        mail.setSubject('Partner Approval Status');
        mail.setPlainTextBody('Not able to create a partner user : '+msg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}