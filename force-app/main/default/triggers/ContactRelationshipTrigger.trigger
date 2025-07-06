trigger ContactRelationshipTrigger on Contact_Relationship__c (before update) {
    Set<Id> newOwnerIds = new Set<Id>();

    for (Contact_Relationship__c cr : Trigger.new) {
        Contact_Relationship__c oldCr = Trigger.oldMap.get(cr.Id);
        if (cr.OwnerId != oldCr.OwnerId) {
            newOwnerIds.add(cr.OwnerId);
        }
    }

    Map<Id, User> userMap = new Map<Id, User>(
        [SELECT Id, Name FROM User WHERE Id IN :newOwnerIds]
    );

    for (Contact_Relationship__c cr : Trigger.new) {
        Contact_Relationship__c oldCr = Trigger.oldMap.get(cr.Id);
        if (cr.OwnerId != oldCr.OwnerId && userMap.containsKey(cr.OwnerId)) {
            cr.Name = userMap.get(cr.OwnerId).Name;
        }
    }
}