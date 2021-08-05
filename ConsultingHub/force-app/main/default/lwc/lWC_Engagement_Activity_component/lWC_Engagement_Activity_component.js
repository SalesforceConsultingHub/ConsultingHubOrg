import { LightningElement ,api, wire, track} from 'lwc';
//import getEngActList from '@salesforce/apex/EnagageActivityController.fetchRecords'; //WORKING
import getEngActMap from '@salesforce/apex/EnagageActivityController.fetchRecordsMap';
export default class whatever extends LightningElement {
    
    @track columns = [{
            label: 'Stage',
            fieldName: 'Stage__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Description',
            fieldName: 'Activity_Description__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Status',
            fieldName: 'Status_Formula__c',
            type: 'text',
            sortable: true
        }
    ];
 
    @track error;
    //@track engActList ; working
    //@wire(getEngActList) //working
    @track engActMapOfListValues = [] ; 
    @wire(getEngActMap) 
    wiredMapofData({
        error,
        data
    }) {

        if(data) {
            for(let key in data) {
                // Preventing unexcepted data
                if (data.hasOwnProperty(key)) { // Filtering the data in the loop
                    this.engActMapOfListValues.push({key: key, value: data[key]});
                }
            }
        }
        else if(error) {
            window.console.log(error);
        }

        /* WORKING
        if (data) {
            this.engActList = data;
        } else if (error) {
            this.error = error;
        }
        */
        

       /*if ( data ) {
           
            var stageArray = [];
            
            //loop through and get all the stages first
            for ( var i = 0; i < data.length; i++ ) {
                if ( data[ i ].Stage__c ){
                    stageArray.push( data[ i ] );

                }
            }

            //for each stage, get the activities associated with it and put them in their own array
        }*/
    }
}