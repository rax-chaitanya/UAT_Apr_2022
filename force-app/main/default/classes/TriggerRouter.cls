/**********************************************************************************

Author: Mohan P K
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger events.

**********************************************************************************/
public class TriggerRouter 
{
    public static void handler(TriggerInterface handler)
    {
      if (handler.isActive())
      {             
         if (Trigger.isBefore )
        {
            if (Trigger.isInsert)
                handler.beforeInsert();
 
            if (Trigger.isUpdate)
                handler.beforeUpdate();
 
            if (Trigger.isDelete)
                handler.beforeDelete();
        }
         
        if (Trigger.isAfter)
        {
            if (Trigger.isInsert)
                handler.afterInsert();
 
            if (Trigger.isUpdate)
                handler.afterUpdate();
 
            if (trigger.isDelete)
                handler.afterDelete();
 
            if (trigger.isUndelete)
                handler.afterUndelete();
        }
      }
    }
}