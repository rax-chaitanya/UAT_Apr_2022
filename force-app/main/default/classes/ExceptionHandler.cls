/*
 * Last Modified : Dec 2021
 * Changes  : SFDC-6711 Chaitanya - Commented the PosttoSlack Method as this is not being used any more and not working for long time and sending apex exceptions
 * Test Case : ExceptionHandler_Test
 */

public class ExceptionHandler {
    
    
    public static String getBody(Exception e) {
        String text;
        //text = '<!channel> \n';
        text = '*Exception Type*: '         + e.getTypeName() + '\n';
        text += '*User ID*: '               + UserInfo.getUserId() + '\n';
        text += '*User Name*: '             + UserInfo.getName() + '\n';
        text += '*Organization ID*: '       + UserInfo.getOrganizationId() + '\n';
        text += '*Instance Name*:'          + UserInfo.getUserName().substringAfterLast('.') + '\n';
        text += '*Cause of exception*: '    + e.getCause() + '\n';
        text += '*Line number*: '           + e.getLineNumber() + '\n';
        text += '*Exception message*: '     + e.getMessage() + '\n';
        text += '*Stack Trace*: '           + e.getStackTraceString() + '\n';
        text += '*URL to Org*: ' +          System.URL.getSalesforceBaseUrl().toExternalForm();
        return text;
    }
    
    public static String getURL() {
        return (String) OrgConstants__c.getInstance('#salesforce-errors').Prod_Value__c;
    }
    
    
    public static void postToAll(Exception e) {
            //postToSlack(e);
            IF(!TEST.ISRUNNINGTEST())
            //postToSlack(getBody(e));  // Commenting this line as slack is not in use by RAX anymore SFDC-6711
            postToChatter(getBody(e));
    }
    
    public static void postToAll(Exception e, Boolean throwException) {
        postToAll(e);
        if (throwException) { throw new CustomException(e.getMessage());}
    }
   
    
    
    
    public static void postToChatter(Exception e) {
        if (!Test.isRunningTest()) {
            FeedItem post = new FeedItem();
            post.ParentId =  (String) OrgConstants__c.getInstance('Salesforce Errors Group').Prod_Value__c;
            post.Body = getBody(e);
            insert post;        
        }
    }
    
    @future
    public static void postToChatter(String str) {
        try {
            
            FeedItem post = new FeedItem();
            post.ParentId =  (String) OrgConstants__c.getInstance('Salesforce Errors Group').Prod_Value__c;
            post.Body = str;
            insert post;
        } catch (Exception ex) {
            IF(!TEST.ISRUNNINGTEST())
            {
            //postToSlack(ex); // Commenting this line as slack is not in use by RAX anymore SFDC-6711
            throw new CustomException('There was a problem posting the application exception to Chatter' + '\n' + getBody(ex));
            //throw new CustomException('There was a problem posting the application exception to Chatter. Check Slack to see what the exception was.');
            }
        }
            
    }
    
    
   /* @future(callout=true)
    public static void postToSlack(String str) {
        Map<String, Object> msg = new Map<String, Object>();
        msg.put('text', str);
        msg.put('mrkdown', true);
        msg.put('username', 'errorbot-' + UserInfo.getUserName().substringAfterLast('.'));
        msg.put('icon_emoji', ':-1:');
        String body = JSON.serialize(msg);
        
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getURL());
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);    }
    
    @future(callout=true)
    public static void postToSlack(Exception e) {
        Map<String, Object> msg = new Map<String, Object>();
        msg.put('text', getBody(e));
        msg.put('mrkdown', true);
        msg.put('username', 'errorbot-' + UserInfo.getUserName().substringAfterLast('.'));
        msg.put('icon_emoji', ':-1:');
        String body = JSON.serialize(msg);
        
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getURL());
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);

        
    } */
     
    

}