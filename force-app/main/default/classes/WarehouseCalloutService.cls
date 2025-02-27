public with sharing class WarehouseCalloutService implements Queueable  {

    private static String endpoint = 'https://th-superbadge-apex.herokuapp.com';
    private static String path = '/equipment';
    private static Map<String, String> equipmentMapper = new Map<String, String>{
        'replacement' => 'Replacement_Part__c',
        'cost' => 'Cost__c',
        'quantity' => 'Current_Inventory__c',
        'lifespan' => 'Lifespan_Months__c',
        'maintenanceperiod' => 'Maintenance_Cycle__c',
        'sku' => 'Warehouse_SKU__c'
    };

    public class WarehouseEquipment {
        public Boolean replacement {get; set;}
        public Integer quantity {get; set;}
        public Decimal cost {get; set;}
        public String name {get; set;}
        public Integer maintenanceperiod {get; set;}
        public Integer lifespan {get; set;}
        public String sku {get; set;}
    }

    public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint + path);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<WarehouseEquipment> equipments = (List<WarehouseEquipment>) JSON.deserialize(response.getBody(), List<WarehouseEquipment>.class);
            List<Product2> prodToUpdate = mapProduct(equipments);
            System.debug(prodToUpdate);
            if (!prodToUpdate.isEmpty()) {
                upsert prodToUpdate; // dml
            }
        }
    }

    private static List<Product2> mapProduct(List<WarehouseEquipment> equipments) {
        List<Product2> prods = new List<Product2>();
        for(WarehouseEquipment weq : equipments) {
            Product2 prod = new Product2(
                Replacement_Part__c = true,
                Cost__c = weq.cost,
                Name = weq.name,
                Current_Inventory__c = weq.quantity,
                Lifespan_Months__c = weq.lifespan,
                Maintenance_Cycle__c = weq.maintenanceperiod,
                Warehouse_SKU__c = weq.sku
            );
            prods.add(prod);
        }
        return prods;
    }
}