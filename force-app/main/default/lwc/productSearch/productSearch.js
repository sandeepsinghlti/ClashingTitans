import { LightningElement, track } from 'lwc';
import searchProducts from '@salesforce/apex/ProductSearchController.searchProducts';

export default class productSearch extends LightningElement {
    @track searchKey = ''; // Stores the search keyword entered by the user
    @track products; // Stores the list of products fetched from the server
    @track error; // Stores any error message encountered during the search

    // Defines the columns for the lightning-datatable
    columns = [
        { label: 'Product Name', fieldName: 'Name' },
        { label: 'Product Code', fieldName: 'ProductCode' },
        { label: 'Description', fieldName: 'Description' }
    ];

    // Handles the change event of the search input field
    handleSearchChange(event) {
        this.searchKey = event.target.value; // Update the search keyword
        this.searchProducts(); // Trigger the product search
    }

    // Calls the Apex method to search for products based on the search keyword
    searchProducts() {
        if (this.searchKey.length > 0) {
            // Call the Apex method with the search keyword
            searchProducts({ searchKey: this.searchKey })
                .then((result) => {
                    this.products = result; // Assign the result to the products list
                    this.error = undefined; // Clear any previous errors
                })
                .catch((error) => {
                    this.error = error.body.message; // Store the error message
                    this.products = undefined; // Clear the products list
                });
        } else {
            this.products = null; // Clear the products list if the search keyword is empty
            this.error = undefined; // Clear any previous errors
        }
    }
}