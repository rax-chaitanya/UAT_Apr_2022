@isTest
public class QuickTextControllerTest

{
public static TestMethod void QuickText_Test1()
    {
       QuickText qtext1 = new QuickText(Name = 'example1',Message = 'message1',Category = 'category1');
        insert qtext1;
        
        QuickTextCreateController.insertQuickText(qtext1.Name,qtext1.Message,qtext1.Category);
          
  }
}