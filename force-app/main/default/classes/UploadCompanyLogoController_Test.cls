@isTest(SeeAllData=true)
public class UploadCompanyLogoController_Test {
    
    @isTest
    static void test_validFileFormat() {
        Account company = TestDataHelper.createTestCompany();
        insert company;
        
        Attachment img = new Attachment(
            Name = 'img.jpg',
            Body = Blob.valueOf('Fake image')
        );
        
    
        ApexPages.StandardController controller = new ApexPages.StandardController( company );
        UploadCompanyLogoController ucl = new UploadCompanyLogoController( controller );
        Attachment a=ucl.attachment;
        
        
        ucl.attachment = img;
        
        ucl.upload();
        ucl.upload(); // throws an error on the page, not sent to Slack
        
        
        //leave page since it was successful
        Attachment img2 = new Attachment(
          //  Name = 'img2.jpg',
            Body = Blob.valueOf('Fake image')
        );
        
        controller = new ApexPages.StandardController( company );
        ucl = new UploadCompanyLogoController( controller );
                
        
        ucl.attachment = img2;
        ucl.upload();
    }
    
    @isTest
        static void test_invalidFileFormat() {
        Account company = TestDataHelper.createTestCompany();
        insert company;
        
        Attachment img = new Attachment(
            Name = 'img.txt',
            Body = Blob.valueOf('Fake image')
        );
        
    
        ApexPages.StandardController controller = new ApexPages.StandardController( company );
        UploadCompanyLogoController ucl = new UploadCompanyLogoController( controller );
        
        
        ucl.attachment = img;
        
        ucl.upload();
        
    }


}