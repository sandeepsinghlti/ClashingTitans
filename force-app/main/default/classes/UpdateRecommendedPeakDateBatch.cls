public with sharing class UpdateRecommendedPeakDateBatch {
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query for products and related orders
        return Database.getQueryLocator([
    select  id, orderId, Product2Id from OrderItem where Order.EffectiveDate =LAST_N_FISCAL_YEARS:1
]);
    }
    
    public void execute(Database.BatchableContext context, List<OrderItem> scope) {
        system.debug('scope '+scope);
        set<id> orderIdSet=new Set<Id>();
      for(OrderItem ord:scope){
      orderIdSet.add(ord.orderid);
      }

        List<Product2> productsToUpdate = new List<Product2>();
        Set<Id> productIds=new Set<Id>();
        Map<Date,Integer> effDateMap=new Map<Date,Integer>();
        for (AggregateResult product : [ select   Order.EffectiveDate effDate,order.id ordId, count(Product2Id) cnt 
                                        from OrderItem where orderId in : orderIdSet 
                                        group by Order.EffectiveDate,order.id]) {
            effDateMap.put((Date)product.get('effDate'),(Integer)product.get('cnt'));
        }
        system.debug('effDateMap '+effDateMap);
        List<OrderItem> ordersList=[Select id, OrderId,Product2Id,Order.EffectiveDate from OrderItem where Order.EffectiveDate in:effDateMap.keySet() ];
        for(OrderItem ord:ordersList){
            Product2 prd2=new Product2(Id=ord.Product2Id,Recommended_Stock_Up_Date__c=ord.Order.EffectiveDate.addDays(365));
            productsToUpdate.add(prd2);
        }
        
        system.debug('Test>>>>>'+productsToUpdate);
        if(productsToUpdate.size()>0){
            update productsToUpdate;
        }
        
    }
    
    public void finish(Database.BatchableContext context) {
        // Batch execution completed
    }
}