@isTest
public with sharing class WarehouseCalloutServiceTest {
    @isTest
    public static void testCalloutService(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        ID jobID = System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        List<Product2> products = [Select Id from Product2];
        System.assertEquals(products.size()>0 , true);
    }
}
