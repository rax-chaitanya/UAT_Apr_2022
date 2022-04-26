global class SandboxRefreshUtility implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) { 

        System.debug(context.organizationId()); 

        System.debug(context.sandboxId()); 

        System.debug(context.sandboxName()); 

        run(); 

    } 

    global static void run() { 

        //List of all emails from the User object  
 
         List<User> userEmailList = [select Email from User where profile.name = 'System Administrator']; 
 
         for(User u : userEmailList) 
 
         { 
 
            System.debug( 'user sandbox email: ' + u.email );

            u.email = u.email.replace('@example.com', '').replace('=', '@').removeEndIgnoreCase( '.invalid' );

            System.debug( 'user reverted email: ' + u.email );
 
             userEmailList.add(u); 
 
         } 
 
         if(userEmailList.size() > 0) 
 
         { 
 
            //  Update userEmailList; 
 
         } 
 
 } 
}