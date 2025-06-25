trigger ContactTrigger on Contact (before insert, before update, before delete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        for(Contact con : Trigger.new) {
            if(con.Phone == '98485') {
                con.OtherCountry = 'India';
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Contact con : Trigger.new) {
            if(con.LeadSource == 'web') {
                con.Title = 'contact record creation';
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        for(Contact con : Trigger.old) {
            if(con.Languages__c == 'English') {
                con.Languages__c.addError('The record is valid');
            }
        }
    }
}