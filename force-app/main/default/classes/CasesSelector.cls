public with sharing class CasesSelector {

    public static List<Case> findCasesBySubject(Id accountId, String subjectSearchTerm) { 
        return [
            SELECT Id, Subject, Status, Priority, AccountId 
            FROM Case 
            WHERE AccountId = :accountId
            AND Subject LIKE :('%' + subjectSearchTerm + '%') 
            // % = n'importe où
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }
}