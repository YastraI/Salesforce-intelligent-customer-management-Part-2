import { LightningElement, api, wire } from 'lwc';
import getCustomerTierInfo from '@salesforce/apex/CustomerTierController.getCustomerTierInfo';

export default class CustomerMedal extends LightningElement {
    @api recordId; // Recebe o ID da Conta automaticamente
    customerData;

    @wire(getCustomerTierInfo, { accountId: '$recordId' })
    wiredCustomer({ error, data }) {
        if (data) {
            this.customerData = data;
        } else if (error) {
            console.error('Erro ao carregar dados do cliente:', error);
        }
    }
}