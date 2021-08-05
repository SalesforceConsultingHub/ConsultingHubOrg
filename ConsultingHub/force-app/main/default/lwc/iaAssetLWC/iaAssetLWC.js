import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAssets from '@salesforce/apex/GetRelatedIAAssets.getAssets';
import noIALabel from '@salesforce/label/c.No_IA_Assets_on_related_Engagement';

const COLUMNS = [
    {label: 'Id', fieldName: 'id', type: 'url', typeAttributes: {label: { fieldName: 'auto' }, target: '_blank'}, sortable: true},
    {label: 'Name', fieldName: 'name'},
    {label: 'Type', fieldName: 'type'},
    {label: 'Location', fieldName: 'location', type: 'url'}
]

export default class IaAssetLWC extends LightningElement
{
    @api recordId;
    @track assets = [];
    @track assetsAvailable = false;
    @track noIA = noIALabel;

    columns = COLUMNS;

    @wire(getAssets, {engagmentActivityId: '$recordId'})
    wiredAssets({error , data})
    {
        if(data)
        {
            let temp = [];
            if(data.length > 0)
            {
                this.assetsAvailable = true;
                data.forEach(element => {
                    let elt = {};
                    elt.auto = element.Name;
                    elt.id = `/${element.Id}`;
                    elt.name = element.Name__c;
                    elt.type = element.Asset_Type__c;
                    elt.location = element.Location__c;
                    temp.push(elt);
                });
    
                this.assets = temp;
            }
        }
        else
        {
            const event = new ShowToastEvent({
                "title": "Problem retrieving assets",
                "message": "There was a problem retrieving the IA assets for this Engagment Activity",
            });
            this.dispatchEvent(event);
        }
    }
    
}