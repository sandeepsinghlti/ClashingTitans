import { LightningElement } from 'lwc';
import getExpiredProducts from '@salesforce/apex/expiredProductsController.getExpiredProducts';


export default class GetExpiredProducts extends LightningElement {
    selectedInterval;
    data;
    isLoading;
    hasResults;
    showNoResults;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Product Code', fieldName: 'ProductCode' },
        { label: 'Expiry Date', fieldName: 'Expiration_Date__c' },
        { label: 'Product Type', fieldName: 'Category__c' }
    ];


    intervalOptions = [
        { label: '1 Day', value: 1 },
        { label: '3 Days', value: 3 },
        { label: '5 Days', value: 5 },
        { label: '30 Days', value: 30 },
        { label: '60 Days', value: 60 },
        { label: '90 Days', value: 90 }
    ];

    handleChange(event) {
        this.selectedInterval = event.detail.value;
        this.fetchData(this.selectedInterval);
        console.log(this.selectedInterval);
    }

    fetchData(selectedInterval) {
        this.isLoading =  true;
        getExpiredProducts({ expiryInterval: selectedInterval })
        .then(data => {
            this.data = data;
            this.hasResults = data.length > 0;
            this.showNoResults = data.length === 0;
        }) .catch((error) => {
                this.data = [];
                this.hasResults = false;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}