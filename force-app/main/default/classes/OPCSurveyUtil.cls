/**
* File :  OPCSurveyUtil.cls
* Description : This class helps to get third friday based on the provided date. Please refer to the SFDC-3707 for more info 
and requirement.
* Created Date : 20.09.2019   
* Author : Raja
*/
public class OPCSurveyUtil {
    
    public Static DateTime thirdFriday(DateTime dtTemp){
        Date d = dtTemp.date().toStartOfMonth();
        DateTime dt = datetime.newInstance(d.Year(),d.Month(),d.day(),0,0,0);
        System.debug(dt.format('EEEE'));
        Datetime thirdFriday;

        if(dt.format('EEEE') == 'Sunday'){  
            thirdFriday = dt.addDays(19);
            System.debug('IfSunday:' + thirdFriday);
        }else if(dt.format('EEEE') == 'Monday'){
            thirdFriday = dt.addDays(18);
            System.debug('IfMonday:' + thirdFriday);
        }else if(dt.format('EEEE') == 'Tuesday'){
            thirdFriday = dt.addDays(17);
            System.debug('IfTuesday:' + thirdFriday);
        }else if(dt.format('EEEE') == 'Wednesday'){
            thirdFriday = dt.addDays(16);
            System.debug('IfWednesday:' + thirdFriday);
        }else if(dt.format('EEEE') == 'Thursday'){
            thirdFriday = dt.addDays(15);
            System.debug('IfThursday:' + thirdFriday);
        }else if(dt.format('EEEE') == 'Friday'){
            thirdFriday = dt.addDays(14);
            System.debug('IfFriday:' + thirdFriday);
        }else if(dt.format('EEEE') == 'Saturday'){
            thirdFriday = dt.addDays(20);
            System.debug('IfSaturday:' + thirdFriday);
        }
        return thirdFriday;
    }

}