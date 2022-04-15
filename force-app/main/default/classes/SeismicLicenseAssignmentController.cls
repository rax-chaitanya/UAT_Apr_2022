/**********************************************************************************

Author: Omkar Narkar
Description: This apex class is created to implement Forum Opt in functionality
IMPORTANT NOTE : Code coverage will be more than 75% only in Production environment since Package licenses are not applicable in sandboxes.

**********************************************************************************/
public without sharing class SeismicLicenseAssignmentController {
	
    @AuraEnabled
    public static Object assignSeismicLicense(){
        Map<String, Object> result = new Map<String, Object>();
        result.put('Licensed', true);
        result.put('Refresh', false);
        if(!UserInfo.isCurrentUserLicensed('seismic')){
            PackageLicense seismicPackageLicense = [SELECT Id, AllowedLicenses, UsedLicenses, NamespacePrefix FROM PackageLicense WHERE NamespacePrefix = 'seismic'];
            if(seismicPackageLicense.UsedLicenses == seismicPackageLicense.AllowedLicenses){
                result.put('Licensed', false);
                return result;
            }
            UserPackageLicense partnerLicense = new UserPackageLicense(PackageLicenseId = seismicPackageLicense.Id, UserId = UserInfo.getUserId());
            Database.insert(partnerLicense);
            result.put('Refresh', true);
        }
        return result;
    }
}