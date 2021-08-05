import { LightningElement, api, wire, track} from 'lwc';
import getModules from '@salesforce/apex/GetRelatedModules.getModules';

const COLUMNS = [
    {label: 'Name', fieldName: 'name'},
    {label: 'Status', fieldName: 'status'},
    {label: 'Must Complete By', fieldName: 'mustCompleteBy'},
    {label: 'Hours Required', fieldName: 'hoursRequired'},
]

export default class OnboardingFlowModulePreview extends LightningElement 
{
    @api OnboardingId;
    @track modules = [];

    columns = COLUMNS;

    //Get all modules related to the onboarding record by default sort order
    @wire(getModules, {onboardingId: '$OnboardingId'})
    wiredAssets({error , data})
    {
        if(data)
        {
            let temp = [];
            
            for(let i = 0; i < data.length; i++)
            {
                let mod = {};
                mod.name = data[i].Name;
                mod.status = data[i].Status__c;
                mod.mustCompleteBy = data[i].Must_Complete_By__c;
                mod.hoursRequired = data[i].Hours_Required__c;
                temp.push(mod);
            }

            this.modules = temp;
        }
        else
        {
            console.log("There was a problem retrieving the preview modules");
        }
    }
}