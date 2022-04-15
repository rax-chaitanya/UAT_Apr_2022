/*
 * Last Modified : Dec 2021
 * Changes  : SFDC-6711 Chaitanya - Commented the PosttoSlack Method call as this is not being used any more
 * Test Class - UploadCompanyLogoController_Test
 */
public without sharing class UploadCompanyLogoController extends Framework {
    
    public Account account;
    public Id OldLogo { get; set; }
    List<attachment> ListOldLogo {get; set;}
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    
    public PageReference goBack() {
        return new PageReference('/' + account.id);
    }
    
    public UploadCompanyLogoController(ApexPages.StandardController controller) {
        try {
            super('UploadCompanyLogoGVF');
            
            System.debug(pageManager);
            
            
            account = (Account)controller.getRecord();
            String companyID = account.id;
            ListOldLogo = Database.query ( queryBuilder.getQueryString ( VF_Query_Manager__c.getInstance('UCL-1').Query_Id__c ) );
            if(ListOldLogo.size() > 0) {
                OldLogo = ListOldLogo.get(0).Id;
            }
        } catch (Exception e) {
            //Exceptionhandler.postToSlack(e); SFDC-6711
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getStackTraceString()));
        }
    }
    public PageReference upload() {
        try {
            if(attachment.name == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Upload_Logo_Val1));
                return null;
            }
            else
            {                
                
                System.debug('attachment: ' + attachment);
                
                string[] types = ( Label.Valid_Image_Types ).replace(' ', '').split(','); 
                set<string> contentTypes = new set<string>();
                contentTypes.addAll(types);
                
                System.debug('types: ' + types);
                System.debug('attachment content types: ' + attachment.ContentType);
                
                string[] splits = attachment.name.split('\\.');
                
                System.debug('splits: ' + splits);
                String fileType = splits[(splits.size() - 1)];
                
                System.debug('fileType: ' + fileType);
                if (contentTypes.contains(fileType)) {
                    
                    if(ListOldLogo.size() != 0) {
                        delete ListOldLogo;
                    }
                    attachment.OwnerId = UserInfo.getUserId();//Current Logged in user ID
                    attachment.ParentId = account.id; // attachment Parent Account record ID
                    attachment.Name='LogoInline';
                                        
                    insert attachment;
                    
                    
                    account.LogoURL__c= '/servlet/servlet.FileDownload?file='+ attachment.Id ;
                    attachment.body = null;
                    
                    
                    update account;
                    
                    
                    return goBack();                    
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Upload_Logo_Val2 ));
                    return null;
                }
            }
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
        
        return null;
    }
    
}