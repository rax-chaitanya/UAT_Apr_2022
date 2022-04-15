public without sharing class QuickTextCreateController {

     @AuraEnabled
    public static String insertQuickText(String name,String message, String category) {  
        QuickText qtext = new QuickText();
        qText.Name = name;
        qText.Message = message;
        qText.Category = category;
        qText.Channel = 'Live Agent';  
        insert qText;   
        if(qText != null){
            QuickTextShare qShare = new QuickTextShare();
            qShare.ParentId = qText.Id;
            qShare.AccessLevel = 'Edit';
            qShare.RowCause = 'Manual';
            qShare.UserOrGroupId = label.QuickTextShare_UserOrGroupId;
            insert qShare;
        }
        return qText.Id;
        }
}