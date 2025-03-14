import { LightningElement, track, api } from 'lwc';
import findCasesBySubject from '@salesforce/apex/AccountCasesController.findCasesBySubject';

const COLUMNS = [
    { label: 'Sujet', fieldName: 'Subject', type: 'text' },
    { label: 'Statut', fieldName: 'Status', type: 'text' },
    { label: 'Priorité', fieldName: 'Priority', type: 'text' },
];

export default class AccountCaseSearchComponent extends LightningElement {
    @api recordId;
    @track cases = [];
    @track error;
    @track noResults = false;
    @track message = ''; // Message dynamique
    searchTerm = '';
    columns = COLUMNS;
    timeoutId; // Variable pour gérer le timeout

    updateSearchTerm(event) {
        this.searchTerm = event.target.value;
    }

    handleSearch() {
        this.noResults = false;
        this.error = undefined;
        this.cases = [];

        // Vérification : si le champ est vide, afficher un message et stopper la recherche
        if (!this.searchTerm.trim()) {
            this.showTemporaryMessage('Veuillez entrer un sujet pour lancer la recherche.', 'error');
            return;
        }

        findCasesBySubject({ accountId: this.recordId, subjectSearchTerm: this.searchTerm })
            .then(result => {
                if (result && result.length > 0) {
                    this.cases = result;
                    this.noResults = false;
                } else {
                    this.cases = [];
                    this.showTemporaryMessage(`Aucun cas trouvé pour le sujet "${this.searchTerm}".`, 'info');
                }
            })
            .catch(error => {
                console.error('Erreur Apex:', error);
                this.showTemporaryMessage('Une erreur est survenue lors de la recherche des cas.', 'error');
                this.cases = [];
            });

            setTimeout(() => this.searchTerm = '', 500);
    }

    showTemporaryMessage(msg, type) {
        this.message = msg;
        this.noResults = type === 'info';
        this.error = type === 'error' ? msg : undefined;

        // Efface l'ancien timeout s'il existe
        clearTimeout(this.timeoutId);
        
        // Efface le message après 2 secondes
        this.timeoutId = setTimeout(() => {
            this.message = '';
            this.noResults = false;
            this.error = undefined;
        }, 2000);
    }
}
