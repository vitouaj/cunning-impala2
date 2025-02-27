@isTest
public with sharing class TEST_WarehouseCalloutService {
    
    @isTest
    static void testEnqueueJob() {
        Test.startTest();        
        Id jobId = System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
    }
}