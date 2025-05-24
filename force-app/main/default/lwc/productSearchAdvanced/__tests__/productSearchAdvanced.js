import { LightningElement, track } from 'lwc';
import searchProducts from '@salesforce/apex/ProductSearchController.searchProducts';
import { NavigationMixin } from 'lightning/navigation';

export default class ProductSearchAdvanced extends NavigationMixin(LightningElement) {
    @track products;
    @track isLoading = false;
    @track hasResults = false;
    @track showNoResults = false;
    searchTerm = '';

    // Handle search input change
    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.searchProducts();
    }

    // Search for products
    searchProducts() {
        if (this.searchTerm.length < 1) {
            this.hasResults = false;
            this.showNoResults = false;
            return;
        }

        this.isLoading = true;
        this.hasResults = false;
        this.showNoResults = false;
        searchProducts({ searchTerm: this.searchTerm })
            .then((result) => {
                this.showProductDetail=false;
                this.products = result;
                this.hasResults = result.length > 0;
                this.showNoResults = result.length === 0;
            })
            .catch((error) => {
                this.products = [];
                this.hasResults = false;
                this.showNoResults = true;
                this.handleError(error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // Handle row click to navigate to record page
    selectedProductId;
    showProductDetail=false;
    handleRowClick(event) {
        console.log('clicked');
        const productId = event.currentTarget.dataset.id;
        this.selectedProductId=productId;
        console.log('this.selectedProductId '+this.selectedProductId);
        // if (productId) {
        //     this[NavigationMixin.Navigate]({
        //         type: 'standard__recordPage',
        //         attributes: {
        //             recordId: productId,
        //             objectApiName: 'Product2',
        //             actionName: 'view'
        //         }
        //     });
        // }
        if (productId) {
        this.showProductDetail=true;
        }
    }

    // Handle errors
    handleError(error) {
        console.error('Error:', error);
    }
}