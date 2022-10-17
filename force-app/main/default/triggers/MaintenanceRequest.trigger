trigger MaintenanceRequest on Case (after update, before update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            MaintenanceRequestHelper.updateWorkOrders(Trigger.new);
        }
    }
}