@isTest
public class ApexDependentPicklistUtility_Test {
	@isTest
    public static void testDependentPicklist(){
        ApexDependentPicklistUtility.getDependentOptions('Account', 'BillingCountryCode', 'BillingStateCode');
        
        ApexDependentPicklistUtility.getPicklistValues('Account', 'BillingCountryCode');
        
        ApexDependentPicklistUtility.PicklistEntry picklistEntry = new ApexDependentPicklistUtility.PicklistEntry();
        picklistEntry.active = 'active';
        picklistEntry.defaultValue = 'defaultValue';
        picklistEntry.label = 'label';
        picklistEntry.validFor = 'validFor';
        picklistEntry.value = 'value';
    }
}