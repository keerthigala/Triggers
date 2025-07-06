trigger OpportunityLineItemTrigger on OpportunityLineItem (
    after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            OpportunityLineItemTriggerHandler.after(Trigger.new);
        } else if (Trigger.isDelete) {
            OpportunityLineItemTriggerHandler.afterDelete(Trigger.old);
        }
    }
}