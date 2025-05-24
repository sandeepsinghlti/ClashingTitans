global class NotifyLowStockProductsBatch implements Database.Batchable<SObject>, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Datetime currentDatetime = System.now();
        String monthText = currentDatetime.format('MMMM');
        return Database.getQueryLocator([
        SELECT Id, Name, Most_Selling_Month__c, StockCount__c, CT_Recommended_Stock_count__c
        FROM Product2
        WHERE Most_Selling_Month__c =:monthText
    ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Product2> scope) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for (Product2 product : scope) {
            String customerEmail = 'mohamedyahya.mohamedabdullathif@ltimindtree.com';
            if( product.StockCount__c < product.CT_Recommended_Stock_count__c){
                if (customerEmail != null) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new List<String>{customerEmail});
                    email.setSubject('Low Stock Notification for ' + product.Name);
                    email.setPlainTextBody('Dear Customer,\n\nThe product ' + product.Name + ' is running low on stock. Please consider placing a new order soon.\n\nThank you.');
                    emailsToSend.add(email);
                }
            }
        }
        system.debug('emailsToSend '+emailsToSend);
        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
    }
}