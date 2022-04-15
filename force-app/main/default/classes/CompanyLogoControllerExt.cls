public with sharing class CompanyLogoControllerExt {
  
  public Account account;
  public Id currentLogo { get; set; }
  public Id OldLogo { get; set; }
  List<attachment> ListOldLogo {get; set;}
  public string success{get;set;}
  public string errormsg {get;set;}
  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }

  public CompanyLogoControllerExt(ApexPages.StandardController controller) {
        
        account = (Account)controller.getRecord();
        ListOldLogo = [SELECT Id FROM Attachment WHERE parentId = :account.id and name LIKE 'LogoInline%'];
        if(ListOldLogo.size() != 0) {
            OldLogo = ListOldLogo.get(0).Id;
        }
  }
  public PageReference upload() {

   
    try {
       
       if(attachment.name==null)
       {
          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Choose a Logo to Upload'));
          errormsg='Error: Choose a Logo to Upload';
          return null;
       }
       else
       {
          String contenttype=attachment.contenttype;
          if(contenttype=='image/jpeg' || contenttype=='image/png' || contenttype=='image/gif' || contenttype=='image/jpg'|| contenttype=='image/bmp' ){

          if(ListOldLogo.size() != 0) {
          delete ListOldLogo;
          }
          attachment.OwnerId = UserInfo.getUserId();//Current Logged in user ID
          attachment.ParentId = account.id; // attachment Parent Account record ID
          attachment.Name='LogoInline';
          insert attachment;
          currentLogo = attachment.Id;
          account.LogoURL__c='/servlet/servlet.FileDownload?file='+currentLogo ;
          update account;
          attachment.body=null;
          success='<script> closePOPup(); </script>';//calling javascript function to close the PopUp
          }
          else
          {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Upload Images only'));
            errormsg='Error: Please Upload Images only';
            return null;
          }
      }
    } catch (Exception e) {
      //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Logo'));
      errormsg='Error: Error uploading Logo';
      return null;
    }
    
    return null;
  }

}