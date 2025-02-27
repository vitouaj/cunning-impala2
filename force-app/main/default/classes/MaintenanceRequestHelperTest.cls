@IsTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    @TestSetup
    static void makeData(){
        mockService.setup();
    }

    @IsTest
    static void updateWorkOrdersTest() {
        List<Case> cases = [SELECT Id, ParentId, Type, Subject, Vehicle__c, Description, Product__c, Date_Reported__c FROM Case LIMIT 5];
        List<Id> caseIds = new List<Id>();
        for (Case cs : cases) {
            caseIds.add(cs.Id);
        }

        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(cases);
        Test.stopTest();

        List<Case> casesCreated = [SELECT Id FROM Case WHERE ParentId IN :caseIds];
        Assert.areEqual(casesCreated.size(), 5, '5 newly created cases should be created');
    }

    @IsTest
    static void updateWorkOrdersShouldReturnEmptyTest() {
        List<Case> cases = new List<Case>();
        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(cases);
        Test.stopTest();

        Date reportedDate = Date.parse('1/1/2025');
        List<Case> casesCreated = [SELECT Id, Date_Due__c FROM Case WHERE Date_Due__c >: reportedDate];
        Assert.areEqual(0, casesCreated.size(), '0 case created');
    }

}