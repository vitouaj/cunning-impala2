@IsTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    @TestSetup
    static void makeData(){
        List<Case> casesToCreate = new List<Case>();

        // Create one Vehicle__c record with sample data
        Vehicle__c vehicle1 = new Vehicle__c(
            Air_Conditioner__c = true,
            Awning__c = 'Manual',
            Backup_Camera_Monitor__c = true,
            Bathroom_Hookup__c = 'Full',
            Bathrooms__c = 1,
            Bedrooms__c = 2,
            Fancy_Sound_System__c = true,
            Generator__c = false,
            Levelers__c = 'Automatic',
            License_Plate__c = 'ABC123',
            Make__c = 'Ford',
            Model__c = 'Explorer',
            Power__c = 'Gas',
            Propane_Tank__c = true,
            Recommended_Passengers__c = 5,
            Roof_Mounted_Antenna__c = false,
            Shower__c = true,
            Tub__c = false,
            Type__c = 'SUV',
            VIN_Number__c = '1HGCM82633A123456'
        );
        insert vehicle1;

        for (Integer i = 1; i <= 10; i++) {
            Case mtCase = new Case();

            mtCase.Type = 'Test Routine Maintenance';
            mtCase.Subject = 'Test Routine Maintenance';
            mtCase.Vehicle__c = vehicle1.Id;
            mtCase.Description = 'test description';
            mtCase.Product__c = cs.Product__c;
            mtCase.Date_Due__c = cs.Date_Reported__c.addDays(minDueDateOfEQs);

            mtCases.add(mtCase);
        }
    }

    @IsTest
    static void updateWorkOrdersTest() {

    }
}