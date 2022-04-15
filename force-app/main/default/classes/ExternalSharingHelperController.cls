/**
 * Created by : Anjaneyulu
 * Created Date: 29/08/2016
 * Reason: Preventing the recursive trigger
 * 
 * */
public class ExternalSharingHelperController {

    // Addede by Anjaneyulu to execute populate lookups method only once.
    public static boolean POPULATE_LOOKUP_FIELDS = true;
  	public static boolean ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
    public static boolean ELIMINATE_DUPLICATE_OPTY_TEAM_MEMBERS = TRUE;	
      public static boolean CREATE_TASK_FOR_CONVERTED_LEADS = true;
    public static boolean POPULATE_OPPTY_RECORD_TYPE = true;
}