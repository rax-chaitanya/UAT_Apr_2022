@isTest
public class QuickTextEditControllerTest {
    public static testMethod void testMethod1(){
        QuickTextEditController controller = new QuickTextEditController();
        Test.setCurrentPage(Page.QuickTextEditPage);
        controller.cancel();
        controller.getCategories();
      }
    public static testMethod void testMethod2(){
      QuickTextEditController controller = new QuickTextEditController();
        Test.setCurrentPage(Page.QuickTextEditPage);
        QuickText q=new QuickText();
        q.Name='test name';
        q.Message='Test Message';
        q.category='Test category';
        insert q;
      QuickTextEditController controller1 = new QuickTextEditController();
		controller.quickTextId=q.id;
        controller.category=q.Category;
        controller.message=q.Message;
        controller.quickText=q.Id;
        QuickText quickRecord=new QuickText();
        quickRecord = [Select Id,Name,Message,Category From QuickText where Id =: controller.quickText ];
        quickRecord.Message=q.Message;
        quickRecord.Category=q.Category;
        update quickRecord;
        controller.save();
        controller.quickText='None';
        controller.save();
            
        }
      public static testMethod void testMethod3(){
        QuickTextEditController controller = new QuickTextEditController();
        	Test.setCurrentPage(Page.QuickTextEditPage);
        	QuickText q=new QuickText();
        	q.Name='test name';
        	q.Message='Test Message';
        	q.category='Test category';
        	insert q;
        controller.quickTextId=q.id;
        controller.category=q.Category;
        controller.message=q.Message;
        controller.quickText=q.Id;
        QuickText quickRecord=new QuickText();
        quickRecord = [Select Id,Name,Message,Category From QuickText where Id =: controller.quickText ];
		controller.getProps();
      }
        
}