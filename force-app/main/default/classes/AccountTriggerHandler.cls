public class AccountTriggerHandler {
    
    public static void run() {
        
        if (Trigger.isBefore && Trigger.isInsert) {
            beforeInsert();
        }

        if (Trigger.isAfter && Trigger.isInsert) {
            //logic
        }

        if (Trigger.isBefore && Trigger.isUpdate) {
            //logic
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            afterUpdate();
        }

        if (Trigger.isBefore && Trigger.isDelete) {
            beforeDelete(Trigger.old);
        }

        if (Trigger.isAfter && Trigger.isDelete) {
        }
    }

    public static void beforeInsert() {
        //logic
    }

    public static void afterUpdate() {
        System.debug(Trigger.new);
    }

    public static void beforeDelete(List<Account> accountOldList) {
        System.debug('Before Delete');
        System.debug(Trigger.old);
        // List<sObject> -> List<Account>

        for (Account acc : (List<Account>) Trigger.old) {
            // for (Account acc : accountOldList)
            acc.addError('Unable to delete');
        }
    }
}