trigger AccountTriggerAI on Account (before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        for (Account acc : Trigger.new) {
            if (acc.Rating == 'Hot' && acc.AnnualRevenue == null) {
                acc.AnnualRevenue = 20000;
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        for (Account acc : Trigger.old) {
            if (acc.ParentId != null) {
                acc.addError('You cannot delete this Account because it is associated with a Parent Account.');
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        for(Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);
            if(acc.Name != oldAcc.Name) {
                List<Contact> contactsToUpdate = [SELECT Id, Account_Name__c FROM Contact WHERE AccountId = :acc.Id];
                for(Contact con : contactsToUpdate) {
                    con.Account_Name__c = acc.Name;
                }
                update contactsToUpdate;  // This may fire another trigger on Contact
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        List<Contact> contactsToDelete = new List<Contact>();
        
        // Step 1: Loop over the deleted accounts
        for (Account acc : Trigger.old) {
            // Step 2: Find contacts linked to this deleted account
            List<Contact> relatedContacts = [
                SELECT Id FROM Contact WHERE AccountId = :acc.Id
            ];
            
            // Step 3: Add them to the list to delete
            contactsToDelete.addAll(relatedContacts);
        }
        
        // Step 4: Delete contacts
        if (!contactsToDelete.isEmpty()) {
            delete contactsToDelete;
        }
    }
    
    if(Trigger.isAfter && Trigger.isunDelete) {
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : Trigger.new) {
            List<Contact> relatedContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            
            for(Contact con : relatedContacts) {
                con.Restored__c = true;
                conList.add(con);
            }
        }
        
        if(!conList.isEmpty()) {
            update conList;
        }
    }
}