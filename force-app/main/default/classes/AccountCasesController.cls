public with sharing class AccountCasesController {
    @AuraEnabled(Cacheable=true)
    public static List<Case> findCasesBySubject(Id accountId, String subjectSearchTerm) {
        return CasesSelector.findCasesBySubject(accountId, subjectSearchTerm);
    }
}