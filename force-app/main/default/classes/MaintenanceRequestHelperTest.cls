@isTest
public with sharing class MaintenanceRequestHelperTest {
    @TestSetup
    static void makeData(){
        List<Product2> products = new List<Product2>();
        List<Equipment_Maintenance_Item__c> items = new List<Equipment_Maintenance_Item__c>();
        // create a vehicle
        Vehicle__c v = new Vehicle__c();
        v.Air_Conditioner__c = true;
        v.Backup_Camera_Monitor__c = true;
        v.Bathrooms__c = 15;
        v.Bedrooms__c = 10;
        insert v;
        // create a request
        Case c = new Case();
        c.Vehicle__c = v.Id;
        c.Type = 'Repair';
        c.Subject = 'Subject test';
        c.Status = 'New';
        insert c;
        // create a product
        Product2 p = new Product2();
        p.Cost__c = 120;
        p.Current_Inventory__c = 200;
        p.Description = 'Description test';
        p.Lifespan_Months__c = 200;
        p.Maintenance_Cycle__c = 120;
        p.Name = 'test';
        p.ProductCode = '200';
        p.Replacement_Part__c = true;
        p.Warehouse_SKU__c = 'test';
        products.add(p);
        Product2 p1 = new Product2();
        p1.Cost__c = 120;
        p1.Current_Inventory__c = 200;
        p1.Description = 'Description test';
        p1.Lifespan_Months__c = 200;
        p1.Maintenance_Cycle__c = 120;
        p1.Name = 'test';
        p1.ProductCode = '200';
        p1.Replacement_Part__c = true;
        p1.Warehouse_SKU__c = 'test';
        products.add(p1);
        insert products;
        // create item
        Equipment_Maintenance_Item__c item1 = new Equipment_Maintenance_Item__c();
        item1.Equipment__c = p.Id;
        item1.Maintenance_Request__c = c.Id;
        items.add(item1);
        Equipment_Maintenance_Item__c item2 = new Equipment_Maintenance_Item__c();
        item2.Equipment__c = p1.Id;
        item2.Maintenance_Request__c = c.Id;
        items.add(item2);
        // without products
        Case c2 = new Case();
        c2.Vehicle__c = v.Id;
        c2.Type = 'Repair';
        c2.Subject = 'Subject2 test';
        c2.Status = 'New';
        insert c2;
        Equipment_Maintenance_Item__c item3 = new Equipment_Maintenance_Item__c();
        item3.Equipment__c = p.Id;
        item3.Maintenance_Request__c = c2.Id;
        items.add(item3);
        insert items;
    }
    @isTest
    public static void updateAllWorkOrders(){
        List<Case> lCases = [SELECT Id,Type from Case];
        for(Case c : lCases){
            c.Type = 'Repair';
            c.Status = 'Closed';
        }
        update lCases;
        List<Case> casesAfterUpdate = [SELECT Id,Type from Case where Type = 'Routine Maintenance'];
        System.assertEquals(casesAfterUpdate.size()>0, true);
    }
    @isTest
    public static void updateWorkOrders(){
        List<Case> lCases = [SELECT Id,Type from Case where Subject = 'Subject2 test'];
        for(Case c : lCases){
            c.Type = 'Repair';
            c.Status = 'Closed';
        }
        update lCases;
        List<Case> casesAfterUpdate = [SELECT Id,Type from Case where Type = 'Routine Maintenance'];
        System.assertEquals(casesAfterUpdate.size()>0, true);
    }

}
