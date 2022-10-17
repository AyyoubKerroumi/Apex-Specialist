public with sharing class WarehouseCalloutService implements Queueable,Database.AllowsCallouts {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    public void execute(QueueableContext ctx){
        List<Product2> lsProd = new List<Product2>();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        HttpResponse response = http.send(req);
        if(response.getStatusCode() == 200) {
            //Deserialize the json response from the
            // Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
            for(Object o : results) {
                Map<String, Object> obj = (Map<String, Object>)o;
                Product2 product = new Product2();
                Integer maintenanceperiod = (Integer)obj.get('maintenanceperiod');               
                Integer Lifespan = (Integer)obj.get('lifespan');
                Integer Cost = (Integer)obj.get('cost');
                Boolean replacement = (Boolean)obj.get('replacement');
                Integer quantity = ((Integer)obj.get('qIntegerntity'));
                product.Name  = (String)obj.get('name'); 
                product.Maintenance_Cycle__c = Integer.valueof(maintenanceperiod);
                product.Cost__c = Cost;
                product.Current_Inventory__c = quantity;
                product.Lifespan_Months__c = Lifespan; 
                product.Replacement_Part__c = replacement;
                product.Warehouse_SKU__c = (String) obj.get('sku');
                product.ProductCode = (String)obj.get('_id');
                lsProd.add(product);
            }
            upsert lsProd;

        }

    }
}
