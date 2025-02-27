public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> cases) {
        // TODO: Complete the method to update workorders
        if (cases.isEmpty()) {
            return;
        }
        List<Case> mtCases = new List<Case>();
        Set<Id> caseIdSet = new Set<Id>();

        for (Case cs : cases) {
            caseIdSet.add(cs.Id);
        }

        Map<Id, Equipment_Maintenance_Item__c> eqMImap = new Map<Id, Equipment_Maintenance_Item__c>([SELECT Id, Maintenance_Request__c, Equipment__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :caseIdSet]);
        Set<Id> productIds = new Set<Id>();

        for (Equipment_Maintenance_Item__c e : eqMImap.values()) {
            productIds.add(e.Equipment__c);
        }

        List<Product2> products = [SELECT Id, Maintenance_Cycle__c FROM Product2 WHERE Id IN: productIds];


        Map<Id, Set<Product2>> caseProdsMap = new Map<Id, Set<Product2>>();
        for(Id id : caseIdSet) {
            Set<Id> pIds = new Set<Id>();
            Set<Product2> prods = new Set<Product2>(); 
            for (Equipment_Maintenance_Item__c eqItem : eqMImap.values()) {
                if (eqItem.Maintenance_Request__c == id) {
                    pIds.add(eqItem.Equipment__c);
                }
            }
            for (Product2 p : products) {
                if (pIds.contains(p.Id)) {
                    prods.add(p);
                }
            }
            caseProdsMap.put(id, prods); // put (id, products);
        }

       
    

        for (Case cs : cases) {
            caseIdSet.add(cs.Id);
            Integer minDueDateOfEQs = calculateMinDueDateOfProducts(new List<Product2>(caseProdsMap.get(cs.Id)));

            Case mtCase = new Case();
            mtCase.ParentId = cs.Id;
            mtCase.Type = 'Routine Maintenance';
            mtCase.Subject = 'Routine Maintenance';
            mtCase.Vehicle__c = cs.Vehicle__c;
            mtCase.Description = cs.Description;
            mtCase.Product__c = cs.Product__c;
            mtCase.Date_Due__c = cs.Date_Reported__c.addDays(minDueDateOfEQs);

            mtCases.add(mtCase);
        }
       
        if (mtCases.size() > 0) {
            insert mtCases;
        }

        List<Equipment_Maintenance_Item__c> eqItems = new List<Equipment_Maintenance_Item__c>();
        for (Case c : mtCases) {
            for (Product2 prod : caseProdsMap.get(c.ParentId)) {
                Equipment_Maintenance_Item__c eqItem = new Equipment_Maintenance_Item__c();
                eqItem.Maintenance_Request__c = c.Id; // new case id
                eqItem.Equipment__c = prod.Id;
                eqItems.add(eqItem);
            }
        }

        if (eqItems.size() > 0) {
            insert eqItems;
        }


    }            

    private static Integer calculateMinDueDateOfProducts(List<Product2> products) {
        Integer minDueDate = (Integer) products[0]?.Maintenance_Cycle__c;
        for (Product2 p : products) {
            if (p.Maintenance_Cycle__c < minDueDate && p.Maintenance_Cycle__c != null) {
                minDueDate = (Integer) p.Maintenance_Cycle__c;
            }
        }
        return minDueDate;
    }
}