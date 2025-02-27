global class WarehouseSyncSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
        String jobId = System.enqueueJob(new WarehouseCalloutService());
   }
}