import { LightningElement, api, wire, track } from "lwc";
import {refreshApex} from "@salesforce/apex";
import getOpportunities from "@salesforce/apex/AccountOpportunitiesController.getOpportunities";

export default class AccountOpportunitiesViewer extends LightningElement {
  @api recordId;
  @track opportunities;
  @track error = ""; // modifier {} par ""
  wiredOpportunitiesResult; // Stocke le résultat pour refreshApex
  @track isLoading = false

  columns = [
    { label: "Nom Opportunité", fieldName: "Name", type: "text" },
    { label: "Montant", fieldName: "Amount", type: "currency" },
    { label: "Date de Clôture", fieldName: "CloseDate", type: "date" },
    { label: "Phase", fieldName: "StageName", type: "text" },
  ];

  // Chargement automatique des opportunités lors du changement de compte
  @wire(getOpportunities, { recordId: "$recordId" })
wiredOpportunities(result) {
  this.wiredOpportunitiesResult = result; // Stocke le résultat du wire
  this.isLoading = true;

  if (result.data) {
    this.opportunities = result.data.length ? result.data : undefined;
    this.error = result.data.length ? undefined : "Aucune opportunité trouvée.";
  } else if (result.error) {
    this.error = result.error.body?.message || "Erreur lors du chargement.";
    this.opportunities = undefined;
  }

  this.isLoading = false;
}


handleRafraichir() {
  this.isLoading = true

  if (this.wiredOpportunitiesResult) {
    refreshApex(this.wiredOpportunitiesResult).then(() => {
      this.isLoading = false
    });
  } else {
    console.warn("Impossible de rafraîchir : aucune donnée en cache.");
    this.isLoading = false
  }
}
}