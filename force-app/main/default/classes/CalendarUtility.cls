public class CalendarUtility{
    public static Date getNthBusinessDay(Date referenceDate, Integer nthBusnessDay){
        Integer count = 0;
        Date nthDay;
        Set<Date> holidays = getHolidays();
        Date startDate = referenceDate.toStartOfMonth();
        do{
            DateTime startDateTime = DateTime.newInstanceGMT(startDate.year(), startDate.month(), startDate.day());
            if(!(startDateTime.format('EEEE') == 'Saturday' || startDateTime.format('EEEE') == 'Sunday' || holidays.contains(startDate))) {
                count++;
                nthDay = startDate;
            }
            startDate = startDate.adddays(1);
        }while(count<nthBusnessDay);
        return nthDay;
    }
    
    public static Integer getBusinessDayCount(){
        Integer count = 0;
        Set<Date> holidays = getHolidays();
        if(holidays.contains(Date.today())){
            return -1;
        }
        Date startDate = Date.Today().toStartOfMonth();
        do{
            DateTime startDateTime = DateTime.newInstanceGMT(startDate.year(), startDate.month(), startDate.day());
            if(!(startDateTime.format('EEEE') == 'Saturday' || startDateTime.format('EEEE') == 'Sunday' || holidays.contains(startDate))) {
                count++;
            }
            startDate = startDate.adddays(1);
        }while(startDate<=Date.today());
        return count;
    }
    
    private static Set<Date> holidaysCached;
    private static Set<Date> getHolidays(){
        if(holidaysCached!=null){
            return holidaysCached;
        }
        holidaysCached = new Set<Date>();
        for(Holiday holiday : [SELECT Id, Name, IsAllDay, ActivityDate FROM Holiday WHERE ActivityDate = THIS_MONTH]){
            holidaysCached.add(holiday.ActivityDate);
        }
        return holidaysCached;
    }
}