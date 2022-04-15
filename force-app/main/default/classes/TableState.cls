public class TableState {
    public Integer currOffset {get; set;}
    public String reRender {get; set;}
    public Integer queryLimit {get; set;}
    public Integer totalCount {get; set;}
    
    
    public void print() {
        System.debug('Current Offset: ' + currOffset + ', ReRender: ' + reRender + ', Query Limit: ' + queryLimit + ', Total Count: ' + totalCount);
        
    }
    public TableState() {
        currOffset = 0;
    }
    
    public TableState(String r) {
        this();
        reRender = r;
    }
    
    
    public Boolean getIsDisabledFirstAndPrev() {
        return (currOffset == 0);
        
    }
    
    public Boolean getIsDisabledNextAndLast() {
        return (currOffset == getMaxOffset());
    }
    
    
    
    
    public Integer getMaxOffset() {
        Integer ret;
        Decimal num = totalCount;
        Decimal denom = queryLimit;
        Double totalPages = num.divide(denom, 5);
        
        ret = (Integer) (Math.floor(totalCount /  queryLimit) * queryLimit);
        if (totalPages == Math.floor(totalCount / queryLimit))
           ret -= queryLimit;
        
        return ret;
    }
    public void first() {
        currOffset = 0;
    }
    
    public void prev() {
        currOffset = (currOffset - queryLimit < 0) ? 0 : currOffset - queryLimit;
    }
    
    public void next() {
        currOffset = (currOffset + queryLimit > 2000) ? 2000 : currOffset + queryLimit;
    }
    
    public void last() {
        currOffset = getMaxOffset();
        
    }
}