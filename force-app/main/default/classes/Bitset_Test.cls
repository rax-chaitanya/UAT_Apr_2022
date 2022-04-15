@isTest
public class Bitset_Test {

    @isTest
    static void poitiveTest(){        
       Bitset bs = new Bitset();
       bs.testBit('',67);
       Boolean result =  bs.testBit('ACCIONLABS1234566778',67);
       System.assertEquals(false,result);
    }
    
     
}