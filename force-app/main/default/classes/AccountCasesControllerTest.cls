// 1. Structure générale
@IsTest
private class AccountCasesControllerTest {
    
// 2.  Méthode @TestSetup pour préparer les données avant d'exécuter les tests
    @TestSetup
    static void setup() {
        // Création d'un compte test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Création d'un case test avec un sujet spécifique
        Case testCase = new Case(
            AccountId = testAccount.Id,
            Subject = 'Test Subject',
            Status = 'New'
        );
        insert testCase;
    }

// 3. Méthode de test testFindCasesBySubject, Vérifie que la méthode retourne bien un seul cas correspondant au sujet spécifié.
    @IsTest
    static void testFindCasesBySubject() {
        // Récupération de l'ID d'un compte test
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Démarrage du test
        Test.startTest();
        // Appel de la méthode à tester
        List<Case> results = AccountCasesController.findCasesBySubject(testAccount.Id, 'Test Subject');
        Test.stopTest();

        // Vérification que le case a bien été trouvé
        Assert.areEqual(1, results.size(), 'Should return one case');
    }
}
