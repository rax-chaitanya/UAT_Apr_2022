public class OppNutcaseGraphController{
    
    public Opportunity opp {get;set;}
    public OppNutcaseGraphController(ApexPages.StandardController contr) {
        opp = (Opportunity)contr.getRecord();
        opp = [Select name,Need_Points__c, Unique_Points__c, Timeframe_Points__c, Cash_Points__c, Authority_Points__c,Solution_Points__c, Enemy_Points__c, Customer_Points__c from Opportunity where id=:opp.id];
    }
    
    public List<String> barColors {get;set;}
    
    
    public Integer getInt(String field) {
        System.debug('getInt(' + field + ')');
        Integer i = (String.isNotBlank((String) opp.get(field))) ? Integer.valueOf((String) opp.get(field)) : 0;
        return i;
    }
    
    public String getColor(Integer i) {
        return ( (i > 0) ? '#00ff00' : '#ff0000' );
    }
    
    public map<String, String> getXToYMap() {
        Map<String, String> mapper = new Map<String, String>();
        for (FieldMapping__c fm :  [SELECT SourceField__c, TargetField__C from FieldMapping__C where CompName__C = 'ONGC' order by SourceField__c]) {
            mapper.put(fm.SourceField__c, fm.TargetField__c);
        }
        return mapper;
    }
    
    public String getbarColorString() {
        return String.join(barColors, ',');
    }
    
    public List<Data> getChartData(){
        barColors = new List<String>();
        List<Data> lsData = new List<Data>();
        map<String, String> xToY = getXToYMap();
        
        System.debug('xToY: ' + xToY); 
        
        for (String key : xToY.keySet()) {
            Integer points = getInt( xToY.get(key) );
            lsData.add(new Data (key, points ));
            barColors.add(getColor(points));
        }

        return lsData;
    }
    // Return a list of data points for a chart
    public List<Data> getData() {
        return getChartData();
    }
    
    // Wrapper class
    public class Data {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Data(String name, Integer data1) {
            this.name = name;
            this.data1 = data1;

        }

    }


}