@IsTest
public with sharing class Test_MaintenanceRequestTrigger {

    @TestSetup
    static void makeData(){
        mockService.setup();
    }

    @IsTest
    static void testTriggerByCaseType() {
        List<Case> cases = [SELECT Id, Status, Type FROM Case];
        List<Id> caseIds = new List<Id>();
        for (Case cs : cases) {
            caseIds.add(cs.Id);
        }
        
        List<Case> casesToUpdate = new List<Case>();
        for (Case cs : cases) {
            Case c = new Case(
                Id = cs.Id,
                Status = 'Closed'
            );
            casesToUpdate.add(c);
        }

        Test.startTest();
        update casesToUpdate;
        Test.stopTest();

        List<Case> newCreatedCases = [SELECT Id, ParentId FROM Case WHERE ParentId IN :caseIds];
        Assert.areEqual(2, newCreatedCases.size(), 'There are only 2 cases of type Repair and Routine Maintenance');
    }
}