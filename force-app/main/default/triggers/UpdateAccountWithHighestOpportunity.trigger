trigger UpdateAccountWithHighestOpportunity on Opportunity (after insert, after update) {
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        if (opp.AccountId != null) {
            accountIds.add(opp.AccountId);
        }
    }

    Map<Id, Decimal> accountMaxAmountMap = new Map<Id, Decimal>();

    List<Opportunity> oppList = [
        SELECT AccountId, Amount 
        FROM Opportunity 
        WHERE AccountId IN :accountIds
    ];

    for (Opportunity opp : oppList) {
        Decimal currentMax = accountMaxAmountMap.get(opp.AccountId);
        if (currentMax == null || opp.Amount > currentMax) {
            accountMaxAmountMap.put(opp.AccountId, opp.Amount);
        }
    }
    
    List<Account> accountsToUpdate = new List<Account>();
    for (Id accId : accountMaxAmountMap.keySet()) {
        accountsToUpdate.add(new Account(Id = accId,Highest_Opportunity_Amount__c = accountMaxAmountMap.get(accId)));
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}