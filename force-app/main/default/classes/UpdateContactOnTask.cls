public without sharing class UpdateContactOnTask implements System.Queueable{
    
    public Map<Id,Id> taskIdVsPrimaryContact{set;get;}
    public List<Task> updateTasks;
    
    public UpdateContactOnTask(Map<Id,Id> mapIds){
        this.taskIdVsPrimaryContact = mapIds;
    }
    
    public void execute(QueueableContext qc){
        
        updateTasks = new List<Task>();
        
        for(Task t : [Select Id,whoid From Task Where Id in : taskIdVsPrimaryContact.keySet()])
            updateTasks.add(new Task(Id=t.id,whoid=taskIdVsPrimaryContact.get(t.id)));
        
        if(updateTasks.size()>0)
            update updateTasks;
        //update tasks;
    }
}