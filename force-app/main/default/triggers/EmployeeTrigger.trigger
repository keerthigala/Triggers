trigger EmployeeTrigger on Employee__c (after delete) {
    Set<Id> accountIds = new Set<Id>();

    // Step 1: Get all related Account Ids from deleted employees
    for (Employee__c emp : Trigger.old) {
        if (emp.Account__c != null) {
            accountIds.add(emp.Account__c);
        }
    }

    if (!accountIds.isEmpty()) {
        // Step 2: Query remaining (non-deleted) Employee__c records
        List<Employee__c> remainingEmployees = [
            SELECT Id, Account__c 
            FROM Employee__c 
            WHERE Account__c IN :accountIds
        ];

        // Step 3: Track which accounts still have employees
        Set<Id> accountsWithRemainingEmployees = new Set<Id>();
        for (Employee__c emp : remainingEmployees) {
                accountsWithRemainingEmployees.add(emp.Account__c);
            }
        
        // Step 4: Deactivate accounts with no employees left
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            if (!accountsWithRemainingEmployees.contains(accId)) {
                accountsToUpdate.add(new Account(
                    Id = accId,
                    Active__c = false
                ));
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}