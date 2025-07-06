trigger CustomerProjectTrigger on Customer_Project__c (after insert, after update) {
    // Collect all Opportunity IDs to update
    Set<Id> oppIdsToUpdate = new Set<Id>();

    for (Customer_Project__c cp : Trigger.new) {
        if (cp.Status__c == 'Active' && cp.Opportunity__c != null) {
            oppIdsToUpdate.add(cp.Opportunity__c);
        }
    }

    if (!oppIdsToUpdate.isEmpty()) {
        List<Opportunity> oppsToUpdate = [SELECT Id, Active_Customer_Project__c FROM Opportunity WHERE Id IN :oppIdsToUpdate];
        for (Opportunity opp : oppsToUpdate) {
            opp.Active_Customer_Project__c = true;
        }
        update oppsToUpdate;
    }
}