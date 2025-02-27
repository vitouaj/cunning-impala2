trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders

    List<Case> caseList = new List<Case>();

    if (Trigger.isUpdate && Trigger.isAfter) {
        for (Case cs : Trigger.new) {
            if (cs.Status == 'Closed' && Trigger.oldMap.get(cs.Id).get('Status') != Trigger.newMap.get(cs.Id).get('Status') && (cs.Type == 'Repair' || cs.Type == 'Routine Maintenance')) {
                caseList.add(cs);
            }
        }
    }

    if (!caseList.isEmpty()) {
        MaintenanceRequestHelper.updateWorkOrders(caseList);
    }

}