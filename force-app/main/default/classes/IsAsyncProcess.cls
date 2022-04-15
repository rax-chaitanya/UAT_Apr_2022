public class IsAsyncProcess{
    public static Boolean checkIsAsyncProcess()
    {
        return !System.isFuture() && !System.isBatch() && !System.isQueueable() && Limits.getLimitFutureCalls() > Limits.getFutureCalls();
    }
}