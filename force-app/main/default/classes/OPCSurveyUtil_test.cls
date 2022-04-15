@isTest

Public class OPCSurveyUtil_test{

    Public static TestMethod Void thirdFridayTest(){
        OPCSurveyUtil.thirdFriday(DateTime.newInstance(2019,10,18,0,0,0));
        OPCSurveyUtil.thirdFriday(DateTime.newInstance(2019,11,15,0,0,0));
        OPCSurveyUtil.thirdFriday(DateTime.newInstance(2020,06,19,0,0,0));
        OPCSurveyUtil.thirdFriday(DateTime.newInstance(2020,01,17,0,0,0));
        OPCSurveyUtil.thirdFriday(DateTime.newInstance(2020,02,15,0,0,0));
        OPCSurveyUtil.thirdFriday(DateTime.newInstance(2020,10,16,0,0,0));
    }
        
}