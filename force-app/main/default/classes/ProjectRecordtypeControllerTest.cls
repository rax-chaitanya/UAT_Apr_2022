@isTest
private class ProjectRecordtypeControllerTest{
    @isTest
    static void TestfetchRecordTypeValues()
    {
        list<String> result=projectRecordtypeController.fetchRecordTypeValues();
        id recId = projectRecordtypeController.getRecTypeId(result[0]);
    }
}