global class CommunityLoginController {
    @AuraEnabled
    global static String checkPortal(String username, String password) {
        
        try {
            aura.redirect(Site.login(username,password, ''));
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }
   
}