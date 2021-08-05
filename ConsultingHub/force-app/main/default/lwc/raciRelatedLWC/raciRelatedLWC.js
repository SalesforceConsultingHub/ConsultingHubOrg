import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRACI from '@salesforce/apex/GetRelatedRACI.getRACI';
import noRACILabel from '@salesforce/label/c.No_RACI_matrix_for_this_Engagement_Activity';

const COLUMNS = [
    {label: 'Id', fieldName: 'id', type: 'url', typeAttributes: {label: { fieldName: 'auto' }, target: '_blank'}, sortable: true},
    {label: 'Stakeholder Name', fieldName: 'stakeholder'},
    {label: 'RACI', fieldName: 'raci'}
]

export default class RaciRelatedLWC extends LightningElement 
{
    @api recordId;
    @track racis = [];
    @track raciAvailable = false;
    @track noRACI = noRACILabel;

    columns = COLUMNS;

    @wire(getRACI, {engagmentActivityId: '$recordId'})
    wiredAssets({error , data})
    {
        if(data)
        {
            let temp = [];
            if(data.length > 0)
            {
                this.raciAvailable = true;
                
                data.forEach(element => {
                    let elt = {};
                    elt.auto = element.Name;
                    elt.id = `/${element.Id}`;
                    elt.stakeholder = element.Stakeholder__r.Name;
                    elt.raci = element.RACI__c;
                    temp.push(elt);
                });
    
                this.racis = temp;
            }
        }
        else
        {
            const event = new ShowToastEvent({
                "title": "Problem retrieving RACI",
                "message": "There was a problem retrieving the related RACI for this Engagment Activity",
            });
            this.dispatchEvent(event);
        }
    }

}