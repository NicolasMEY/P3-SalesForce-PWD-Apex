public with sharing class AccountOpportunitiesController {
    @AuraEnabled(Cacheable=true)
    public static List<Opportunity> getOpportunities(Id recordId) {
        return OpportunitySelector.getOpportunitiesByAccountId(recordId);
    }
}