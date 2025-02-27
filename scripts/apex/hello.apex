

// String endpoint = 'https://th-superbadge-apex.herokuapp.com/equipment';
// Http http = new Http();
// HttpRequest request = new HttpRequest();
// request.setEndpoint(endpoint);
// request.setMethod('GET');
// HttpResponse response = http.send(request);  

// List<WarehouseCalloutService.WarehouseEquipment> results = (List<WarehouseCalloutService.WarehouseEquipment>) JSON.deserialize(response.getBody(), List<WarehouseCalloutService.WarehouseEquipment>.class);


// ID jobID = System.enqueueJob(new WarehouseCalloutService());
// System.debug(jobID);


// WarehouseSyncSchedule sch = new WarehouseSyncSchedule();

// String cronExpression = '0 0 0 * * ?'; // Runs daily at midnight UTC
// System.schedule('WarehouseSyncScheduleJob', cronExpression, sch);

Date d = Date.parse('1/1/2025');
System.debug(d);