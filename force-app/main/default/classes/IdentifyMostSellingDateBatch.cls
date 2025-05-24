public class IdentifyMostSellingDateBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Product2Id, OrderItem.CloseDate, SUM(OrderItem.Quantity) totalQuantity
            FROM OrderItem
            GROUP BY Product2Id, OrderItem.CloseDate
        ]);
    }

    public void execute(Database.BatchableContext bc, List<OrderItem> scope) {
        Map<Id, Map<Date, Decimal>> productSalesMap = new Map<Id, Map<Date, Decimal>>();

        for (AggregateResult result : (List<AggregateResult>) scope) {
            Id productId = (Id) result.get('Product2Id');
            Date closeDate = (Date) result.get('CloseDate');
            Decimal totalQuantity = (Decimal) result.get('totalQuantity');

            if (!productSalesMap.containsKey(productId)) {
                productSalesMap.put(productId, new Map<Date, Decimal>());
            }

            productSalesMap.get(productId).put(closeDate, totalQuantity);
        }

        List<Product2> productsToUpdate = new List<Product2>();

        for (Id productId : productSalesMap.keySet()) {
            Map<Date, Decimal> salesMap = productSalesMap.get(productId);
            Date mostSellingDate = null;
            Decimal maxQuantity = 0;

            for (Date saleDate : salesMap.keySet()) {
                if (salesMap.get(saleDate) > maxQuantity) {
                    maxQuantity = salesMap.get(saleDate);
                    mostSellingDate = saleDate;
                }
            }

            productsToUpdate.add(new Product2(Id = productId, Most_Selling_Date__c = mostSellingDate));
        }

        if (!productsToUpdate.isEmpty()) {
            update productsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
    }
}
