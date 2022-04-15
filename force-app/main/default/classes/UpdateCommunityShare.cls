public class UpdateCommunityShare implements System.Queueable{
    
    public List<sobject> records{set;get;}
    public String operation{set;get;}
    public UpdateCommunityShare(List<sobject> records,String operation){
        this.records = records;
        this.operation = operation;
    }
    
    public void execute(System.QueueableContext qc){
        try{
            if(Operation == 'Insert'){
                if(records.size() < 10000)
                    Database.insert(records,false);
                else{
                    List<sobject> recs = new List<sobject>();
                    Integer k=1;
                    for(Integer i=0;i<records.size();i++){
                        recs.add(records.get(i));
                        k++;
                        
                        if(k == 2000){
                            Database.insert(recs,false);
                            recs = new List<sobject>();
                            k=0;
                        }
                    }
                }
            }    
            
            if(Operation == 'Delete'){
                if(records.size() < 10000)
                    Database.Delete(records,false);
                else{
                    List<sobject> recs = new List<sobject>();
                    Integer k=1;
                    for(Integer i=0;i<records.size();i++){
                        recs.add(records.get(i));
                        k++;
                        
                        if(k == 2000){
                            Database.Delete(recs,false);
                            recs = new List<sobject>();
                            k=0;
                        }
                    }
                }
            }
        }catch(Exception e){}
    }
}