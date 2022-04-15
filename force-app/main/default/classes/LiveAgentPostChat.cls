public without sharing  class LiveAgentPostChat
{ 
    public String chatFeedback {get;set;}
    public String chatKey {get;set;}
    public LiveAgentPostChat(){
        chatKey =ApexPages.currentPage().getParameters().get('chatKey');
    }
    public String Feedback {get;set;}
    public NPS_Survey__c survey = new NPS_Survey__c();
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','0')); 
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        return options; 
    }
    public Pagereference save(){
       
        
        if(Feedback==null && chatFeedback=='')
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please provide chat experience and short reason for your score.'));
            return null;   
        }
        else  if(Feedback== null){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please rate chat experience.'));
            return null;   
        }
        
        else if (chatFeedback=='')
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please provide short reason for your score.'));
            return null;   
        }
        else {
        survey.Chat_Experience__c=decimal.valueOf(Feedback);
        survey.ChatKey__c = chatKey;
        Survey.PostChatComment__c=chatFeedback;
        survey.ChatKey__c = chatKey;
        insert survey; 
        PageReference newPage = Page.PostChatSuccesspage;
        return newPage;
        }
    }

}