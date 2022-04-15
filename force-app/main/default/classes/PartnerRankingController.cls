public without sharing class PartnerRankingController {
    public Integer i;
    Public String PartnerName;
    public string strDtFilter{get;set;}
    public String barColor { get; set; }
    public PartnerRankingController() 
    {
        
        if(strDtFilter == null)
            strDtFilter='Year';
        
    }  
    public List<Data> getchartData(){
        
        PartnerName = [Select name,id,Account.Name from User where id =: UserInfo.getUserId()].Account.Name;
        String soqlQuery;  
        i=1;      
        if(strDtFilter=='Year')
        {
            String OppDtFilter='and CALENDAR_YEAR(CloseDate)='+System.Today().Year();
            soqlQuery = 'Select Partner_Company__r.Name accname,sum(Amount) OppAmount from Opportunity where StageName=\'Closed Won\' and Partner_Company__c!=null '+OppDtFilter+' group by Partner_Company__r.Name order by sum(Amount) DESC';
            
        }
        else if(strDtFilter=='Quarter')
        {
            Period pr =[Select StartDate,EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER Limit 1];
            String dt1=String.valueOf(pr.StartDate);
            dt1=dt1.replace(' 00:00:00','');
            String dt2=String.valueOf(pr.EndDate);
            dt2=dt2.replace(' 00:00:00','');
            
            
            String OppDtFilter='and CloseDate>='+dt1+' and CloseDate<='+dt2;
            soqlQuery = 'Select Partner_Company__r.Name accname,sum(Amount) OppAmount from Opportunity where StageName=\'Closed Won\' and Partner_Company__c!=null '+OppDtFilter+' group by Partner_Company__r.Name order by sum(Amount) DESC';
        }
        List<AggregateResult> arList = database.query(soqlQuery);
        //List<AggregateResult> arList = [Select Partner_Company__r.Name accname,sum(Approval_Amount__c) OppAmount from Opportunity where StageName='Closed Won' and Partner_Company__c!=null '+OppDtFilter+' group by Partner_Company__r.Name order by sum(Approval_Amount__c) DESC];
        List<Data> dataList= new List<Data>();
        
        barColor = '';        
        for (Integer x = 0;x < arList.size();x++)
        {
            AggregateResult ar = arList.get(x);
            String CompanyName= String.valueOf(ar.get('accname'));
            Decimal total= Double.valueOf(ar.get('OppAmount'));
            
            if(x < 10){
                if(partnerName == companyName){  
                    companyName = companyName.substring(0, Math.min(companyName.length(), 10))+'...';
                    barColor += '#0A9208,';
                    dataList.add(new Data(CompanyName+'('+(x+1)+')', total,partnerName+'('+(x+1)+')')); 
                }
                else {
                    barColor +='#2E9AFE,';
                    dataList.add(new Data(String.valueOf(x+1), total,String.valueOf(x+1)));
                }
            }else if(partnerName == companyName){
                companyName = companyName.substring(0, Math.min(companyName.length(), 10))+'...';
                barColor += '#0A9208';
                dataList.add(new Data(CompanyName+'('+(x+1)+')', total,partnerName+'('+(x+1)+')'));}
            
        }
        return dataList;
    }
    
    public class Data {
        
        public String name { get; set; }
        public String titlename { get; set; }
        public Decimal data1 { get; set; }
        public String ChartLabel { get; set; }        
        public Data(String name, Decimal data1,String titlename) {
            this.name = name;
            this.titlename = titlename;
            this.data1 = data1;
            this.ChartLabel = '$'+data1.format();
            
        }
    }
    
    
}