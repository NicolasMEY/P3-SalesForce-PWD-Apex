@IsTest
public class TestDataFactory {
    public static Account createTestAccount() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        return acc;
    }

    public static Opportunity createTestOpportunity(Id accountId) {
        Opportunity opp = new Opportunity(
                Name='Test Opportunity',
                StageName='Prospecting',
                CloseDate=System.today().addDays(30),
                Amount=10000,
                AccountId=accountId
        );
        insert opp;
        return opp;
    }

      // Création d'un cas de test
      public static Case createTestCase(Id accountId, String subject, String status) {
        Case c = new Case(
            AccountId = accountId,
            Subject = subject,
            Status = status
        );
        insert c;
        return c;
    }
}