public with sharing class ProductDetailsController {
    @AuraEnabled
    public static Product2 getProductDetails(Id productId) {
        try {
            // Query product details including necessary fields
            Product2 product = [select Id, Name, ProductCode, Description, IsActive, Family, ExternalId, DisplayUrl, QuantityUnitOfMeasure, Expiration_Date__c, Brand__c, Category__c, SubCategory__c, StockCount__c, Stock_Up__c, Recommended_Stock_Up_Date__c, CT_Recommended_Stock_count__c, Most_Selling_Date__c, Most_Selling_Month__c, Most_Selling_Year__c
             from Product2 
                                WHERE Id = :productId
                                WITH SECURITY_ENFORCED
                                LIMIT 1];
            return product;
        } catch (Exception e) {
            // Handle any exceptions and throw an AuraHandledException
            throw new AuraHandledException('Error retrieving product details: ' + e.getMessage());
        }
    }
}