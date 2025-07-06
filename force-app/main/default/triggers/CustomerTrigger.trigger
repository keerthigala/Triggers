trigger CustomerTrigger on Customer__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        CustomerTriggerHandler.addAccountManagerToTeam(Trigger.new);
    }
}