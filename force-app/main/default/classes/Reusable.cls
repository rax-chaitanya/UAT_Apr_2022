public class Reusable {
    
    public static Object getValue (SObject sObj, String fieldName) {
        if (!fieldName.containsAny('.')) {
            String type = sObj.getSObjectType().getDescribe().getName();            
            System.debug('value of : ' + type + '.' + fieldName + ' is ' + String.valueOf(sObj.get(fieldName)));
            return sObj.get(fieldName);
        } else {
            List<String> lookUpFields = fieldName.split('\\.');
            System.debug(lookupfields);
            SObject dummyObj = sObj.getSObject(lookupFields[0]);
            
            if (lookupFields.size() > 2) {
                try {
                    for (Integer i = 1; i < lookUpFields.size() - 1; ++i) {
                        System.debug(lookupFields[i]);
                        dummyObj = dummyObj.getSObject(lookupFields[i]);
                        System.debug(dummyObj);
                    }
                } catch (Exception e) {
                    return null;
                }
            }
            return dummyObj.get(lookupFields[lookupFields.size() - 1]);
        }
    }
    
    
    public static Boolean amInSkipUserIds() {
        return Label.SkipUserIds.contains(userinfo.getuserid());        
    }
    
    public static Boolean amInAdminProfiles() {
        return Label.SkipUserIds.contains(userinfo.getProfileId());   
    }
    
    public static Boolean amFoundationUser() {
        return Userinfo.getUserid().contains(label.FMWFoundationUser);
    }
    
    public static Boolean amFMWAPIUser() {
        return Userinfo.getUserid().contains(label.FMW_API_User);
    }
    
    public static Boolean amFMWAPIOrFoundationUser() {
        return amFoundationUser() || amFMWAPIUser();
    }
}