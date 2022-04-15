@isTest
public class Framework_Test {
    @isTest
    public static void testGetTrue(){
        String T = 'true';
        Framework f = new Framework();
		String getT = f.getTrue();
		System.assert(T == getT);
    }

}