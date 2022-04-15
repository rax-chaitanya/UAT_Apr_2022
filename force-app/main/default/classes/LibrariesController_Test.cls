@isTest(seeAlldata=true)
public class LibrariesController_Test{
    @isTest
    public static void librariesTest(){
        List<LibrariesController.DataFiles> result = LibrariesController.getLibraries();
        system.assertEquals(result.size()>0, true);
    }
    
}