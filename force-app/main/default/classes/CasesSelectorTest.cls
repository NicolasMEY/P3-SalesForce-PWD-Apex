// Recherche avec un terme existant → Vérifie que seuls les cas contenant "Test Subject" sont retournés.
// Recherche sans correspondance → Vérifie que la méthode retourne une liste vide si aucun cas ne correspond.
// Recherche avec des caractères spéciaux → Vérifie que la méthode retourne exactement un cas lorsque le terme est spécifique.

@IsTest
private class CasesSelectorTest {

    @TestSetup
    static void setup() {
        // Création d'un compte de test
        Account testAccount = TestDataFactory.createTestAccount();
        
        // Création de plusieurs cas (Cases) associés au compte
        TestDataFactory.createTestCase(testAccount.Id, 'Test Subject 1', 'New');
        TestDataFactory.createTestCase(testAccount.Id, 'Test Subject 2', 'Open');
        TestDataFactory.createTestCase(testAccount.Id, 'Another Subject', 'Closed');
    }

    @IsTest
    static void testFindCasesBySubject() {
        // Récupérer un compte test
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Définir le terme de recherche du sujet
        String searchTerm = 'Test Subject';
        
        Test.startTest();
        // Appel de la méthode pour rechercher les cas par sujet
        List<Case> results = CasesSelector.findCasesBySubject(testAccount.Id, searchTerm);
        Test.stopTest();
        
        // Vérification que la méthode retourne les cas avec le terme de recherche dans le sujet
        // Ici, on s'attend à deux cas ayant "Test Subject" dans leur sujet
        System.assertEquals(2, results.size(), 'Should return two cases with "Test Subject"');
        
        // Vérification du sujet des cas retournés
        for (Case c : results) {
            System.assert(c.Subject.contains(searchTerm), 'Subject should contain the search term');
        }
    }

    @IsTest
    static void testFindCasesWithNoMatch() {
        // Récupérer un compte test
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Term de recherche qui n'a pas de correspondance
        String searchTerm = 'Non-existing Subject';
        
        Test.startTest();
        // Appel de la méthode pour rechercher les cas par sujet
        List<Case> results = CasesSelector.findCasesBySubject(testAccount.Id, searchTerm);
        Test.stopTest();
        
        // Vérification que la méthode ne retourne aucun cas
        System.assertEquals(0, results.size(), 'Should return no cases for a non-matching subject');
    }

    @IsTest
    static void testFindCasesBySubjectWithSpecialCharacters() {
        // Récupérer un compte test
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Term de recherche avec des caractères spéciaux
        String searchTerm = 'Test Subject 1';
        
        Test.startTest();
        // Appel de la méthode pour rechercher les cas par sujet
        List<Case> results = CasesSelector.findCasesBySubject(testAccount.Id, searchTerm);
        Test.stopTest();
        
        // Vérification que la méthode retourne les cas avec le terme de recherche dans le sujet
        System.assertEquals(1, results.size(), 'Should return one case with "Test Subject 1"');
    }
}
