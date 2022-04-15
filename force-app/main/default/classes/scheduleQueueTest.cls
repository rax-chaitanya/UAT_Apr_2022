@isTest
public class scheduleQueueTest{
    static testMethod void testDefaultMockValues(){
    scheduleQueue s = new scheduleQueue();
    SchedulableContext c;
    s.execute(c);
    }
}