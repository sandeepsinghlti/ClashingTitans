public with sharing class ProductSearchController {

    @AuraEnabled(cacheable=true)
    public static List<Product2> searchProducts(String searchTerm) {
        String searchPattern = '%' + searchTerm + '%';
        return [
            SELECT Id, Name, ProductCode, Description
            FROM Product2
            WHERE Name LIKE :searchPattern
            WITH SECURITY_ENFORCED
        ];
    }
}