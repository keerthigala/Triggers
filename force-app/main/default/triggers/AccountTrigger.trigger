trigger AccountTrigger on Account (before insert, before update, before delete, after update) {
    AccountTriggerHandler.run();
}