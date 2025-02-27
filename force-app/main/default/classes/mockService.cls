global class mockService {
    
    global static void setup() {
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

        List<Product2> prods = new List<Product2>();
        Integer prodCode = 10003;
        for (Integer i = 1; i <= 5; i++) {
            Product2 prod1 = new Product2(
                Name = 'Test Generator' + String.valueOf(i) + ' 1000 kW',
                ProductCode = String.valueOf(prodCode + i),
                Description = 'Medium RainbowBot',
                Cost__c = 5000 + i*100, // Assuming this is a decimal field
                Current_Inventory__c = 5 + i,
                Lifespan_Months__c = 120 + i,
                Maintenance_Cycle__c = 200 - i,
                Replacement_Part__c = true,
                Warehouse_SKU__c = String.valueOf(i)
            );
            prods.add(prod1);

            Case mtCase = new Case();
            mtCase.Type = 'Test' + i + ' Routine Maintenance';
            mtCase.Subject = 'Test' + i + ' Routine Maintenance';
            mtCase.Vehicle__c = vehicle1.Id;
            mtCase.Description = 'test description';
            mtCase.Product__c = 'GC1060';
            mtCase.Date_Reported__c = Date.parse('1/1/2025');
            casesToCreate.add(mtCase);
        }
        insert prods;
        insert casesToCreate;

        // test data for trigger
        Case case1 = new Case();
        case1.Type = 'Repair';
        case1.Subject = 'Test Routine Maintenance';
        case1.Vehicle__c = vehicle1.Id;
        case1.Description = 'test description';
        case1.Product__c = 'GC1060';
        case1.Status = 'Working';
        case1.Date_Reported__c = Date.parse('1/1/2025');

        Case case2 = new Case();
        case2.Type = 'Routine Maintenance';
        case2.Subject = 'Test2 Routine Maintenance';
        case2.Vehicle__c = vehicle1.Id;
        case2.Description = 'test description';
        case2.Status = 'Working';
        case2.Product__c = 'GC1062';
        case2.Date_Reported__c = Date.parse('1/1/2025');

        List<Case> caseTrigger = new List<Case>{case1, case2};
        insert caseTrigger;

        List<Equipment_Maintenance_Item__c> eqItems = new List<Equipment_Maintenance_Item__c>();

        for(Integer i = 0; i<5; i++) {
            Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(
                Equipment__c = prods[i].Id,
                Maintenance_Request__c = casesToCreate[i].Id,
                Quantity__c = 4
            );

            Equipment_Maintenance_Item__c item2 = new Equipment_Maintenance_Item__c(
                Equipment__c = prods[4-i].Id,
                Maintenance_Request__c = casesToCreate[i].Id,
                Quantity__c = 5
            );
            eqItems.add(item);
            eqItems.add(item2);
        }

        for (Product2 p : prods) {
            for (Case cs : caseTrigger) {
                Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(
                    Equipment__c = p.Id,
                    Maintenance_Request__c = cs.Id,
                    Quantity__c = 2
                );
                eqItems.add(item);
            }
        }

        insert eqItems;
    }
}