import { LightningElement, api, track } from 'lwc';
import getProductDetails from '@salesforce/apex/ProductDetailsController.getProductDetails';

export default class ProductDetails extends LightningElement {
    @api recordId; // Product Id passed from the parent or record page
    @track product;
    @track isLoading = false;
    @track error;

    connectedCallback() {
        this.fetchProductDetails();
    }

    // Fetch product details from Apex
    fetchProductDetails() {
        this.isLoading = true;
        this.error = null;

        getProductDetails({ productId: this.recordId })
            .then((result) => {
                this.product = result;
            })
            .catch((error) => {
                this.error = 'Error loading product details: ' + error.body.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}