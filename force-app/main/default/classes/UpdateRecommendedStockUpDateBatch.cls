public class UpdateRecommendedStockUpDateBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query for products and related orders
        return Database.getQueryLocator([
            SELECT Id, Recommended_Stock_Up_Date__c, (SELECT Id, CreatedDate FROM Orders__r ORDER BY CreatedDate DESC LIMIT 1)
            FROM Product2
        ]);
    }

    public void execute(Database.BatchableContext context, List<Product2> scope) {
        List<Product2> productsToUpdate = new List<Product2>();

        for (Product2 product : scope) {
            if (product.Orders__r.size() > 0) {
                // Get the most recent order's created date
                Datetime latestOrderDate = product.Orders__r[0].CreatedDate;
                // Calculate the recommended stock up date (e.g., 30 days after the latest order)
                Date recommendedStockUpDate = latestOrderDate.addDays(30).date();

                // Update the product's Recommended Stock Up Date field
                product.Recommended_Stock_Up_Date__c = recommendedStockUpDate;
                productsToUpdate.add(product);
            }
        }

        // Update the products with the new recommended stock up dates
        update productsToUpdate;
    }

    public void finish(Database.BatchableContext context) {
        // Batch execution completed
    }
}

