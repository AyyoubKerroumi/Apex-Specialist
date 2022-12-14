public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> existingMainReq) {
        // TODO: Complete the method to update workorders
        Integer count = 0;
        Map<Id, Integer> toGetDueDateMap = new Map<Id, Integer>();
        Map<Id,Case> newCasesToIdsMap = new Map<Id,Case>();
        List<Case> createNewMainReq = new List<Case>();
        List<Case> caseIdsList = new List<Case>();
        Map<Equipment_Maintenance_Item__c,Id> EquipMainItemsToProdIds = new Map<Equipment_Maintenance_Item__c,Id>();
        
        if(!existingMainReq.isEmpty()){
            for(Case cc : existingMainReq){
                if((cc.Type == 'Repair' || cc.Type == 'Routine Maintenance') && cc.Status == 'Closed'){
                    caseIdsList.add(cc);   
                }
            }    
        }
        List<Equipment_Maintenance_Item__c> equipMainList = [Select id,Equipment__c,Maintenance_Request__c from Equipment_Maintenance_Item__c where Maintenance_Request__c IN : caseIdsList];
        if(!equipMainList.isEmpty()){
            for(Equipment_Maintenance_Item__c equipMainn : equipMainList){
                EquipMainItemsToProdIds.put(equipMainn,equipMainn.Equipment__c);
                system.debug(EquipMainItemsToProdIds.size());
                if(EquipMainItemsToProdIds.size() > 1){
                    count = EquipMainItemsToProdIds.size();
                }
            }  
        }
      List<Equipment_Maintenance_Item__c> EMIList = [Select Equipment__r.Maintenance_Cycle__c,Equipment__c from Equipment_Maintenance_Item__c where Equipment__r.Id IN :EquipMainItemsToProdIds.values() AND Maintenance_Request__c IN:caseIdsList order By Equipment__r.Maintenance_Cycle__c ASC limit 1];
            for(Equipment_Maintenance_Item__c equip : EMIList){
                toGetDueDateMap.put(equip.Id,Integer.valueOf(equip.Equipment__r.Maintenance_Cycle__c));  
                for(Case c : caseIdsList){
                    Case mainRe = new Case();
                    mainRe.Vehicle__c = c.Vehicle__c;
                    mainRe.status = 'New';
                    mainRe.Type = 'Routine Maintenance';
                    mainRe.Subject = 'New Main Request For Vehicle for Apex Specialist';
                    mainRe.Date_Reported__c = date.today();
                    if(count > 1){
                        mainRe.Date_Due__c = Date.today().addDays(toGetDueDateMap.get(equip.Id));
                    }
                    else{
                        mainRe.Date_Due__c = Date.today();
                    }
                    createNewMainReq.add(mainRe);
                    newCasesToIdsMap.put(c.Id,mainRe);
                }  
               insert createNewMainReq; 
                if(caseIdsList.size()>0 && newCasesToIdsMap.size()>0){
                        cloneEquipItems(caseIdsList,newCasesToIdsMap);
                    }
            }
    }
    public static void cloneEquipItems(List<case> closedCaseRecords, Map<Id,case> newCreatedCasesMapp){
        List<Equipment_Maintenance_Item__c> newEquipItems = new List<Equipment_Maintenance_Item__c>();
            if(!closedCaseRecords.isEmpty() && newCreatedCasesMapp.size()>0){
                List<Equipment_Maintenance_Item__c> oldEquipItems = [SELECT Equipment__c, Maintenance_Request__c, Quantity__c,Maintenance_Request__r.Id
                                                                     FROM Equipment_Maintenance_Item__c
                                                                     WHERE  Maintenance_Request__c IN :closedCaseRecords];
                
                for(Equipment_Maintenance_Item__c equipItem : oldEquipItems) {
                    
                    Equipment_Maintenance_Item__c newItem = equipItem.clone(false, true, false, false);
                    newItem.Maintenance_Request__c = newCreatedCasesMapp.get(equipItem.Maintenance_Request__c).id;
                    newEquipItems.add(newItem);
                }
                insert newEquipItems;
            }
    }
}