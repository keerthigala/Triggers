trigger DefaultAnnualRevenue on Account (before insert, before delete) {
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
}