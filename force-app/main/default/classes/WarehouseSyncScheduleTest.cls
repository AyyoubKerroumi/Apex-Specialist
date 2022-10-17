@isTest
public with sharing class WarehouseSyncScheduleTest {
    @isTest
    public static void testSync(){
        Test.SetMock(HttpCallOutMock.class, new WarehouseCalloutServiceMock());
        String CRON_EXP = '0 0 0 3 9 ? 2042';
        Test.startTest();
        String jobId = System.schedule('test Sync WareHouse', CRON_EXP, new WarehouseSyncSchedule());
        Test.stopTest();
        CronTrigger ct = [SELECT Id,  CronExpression,  TimesTriggered,  NextFireTime FROM CronTrigger WHERE Id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
    }
}
