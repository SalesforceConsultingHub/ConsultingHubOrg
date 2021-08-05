import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getModules from '@salesforce/apex/GetRelatedModules.getModules';

const COLUMNS = [
    {label: 'Id', fieldName: 'id', type: 'url', typeAttributes: {label: { fieldName: 'auto' }, target: '_blank'}, sortable: true},
    {label: 'Status', fieldName: 'status'},
    {label: 'Must Complete By', fieldName: 'mustCompleteBy'},
    {label: 'Hours Required', fieldName: 'hoursRequired'},
    {label: 'Actual Hours Spent', fieldName: 'actualHoursSpent'}
]

export default class SortedModules extends LightningElement 
{
    @api recordId;
    @track modules = [];

    columns = COLUMNS;

    @wire(getModules, {onboardingId: '$recordId'})
    wiredAssets({error , data})
    {
        if(data)
        {
            let temp = [];
            data.forEach(element => {
                let elt = {};
                elt.auto = element.Name;
                elt.id = `/${element.Id}`;
                elt.status = element.Status__c;
                elt.mustCompleteBy = element.Must_Complete_By__c;
                elt.hoursRequired = element.Hours_Required__c;
                elt.actualHoursSpent = element.Actual_Hours_Spent__c;
                temp.push(elt);
            });

            this.modules = temp;
        }
        else
        {
            const event = new ShowToastEvent({
                "title": "Problem retrieving Modules",
                "message": "There was a problem retrieving the related modules for this Onboarding Record",
            });
            this.dispatchEvent(event);
        }
    }
}