import { LightningElement, api, wire, track } from 'lwc';
import getAssignedModules from '@salesforce/apex/OnboardingFlowHelper.getAssignedModules';
import updateModules from '@salesforce/apex/OnboardingFlowHelper.updateModules';
import {FlowNavigationNextEvent, FlowNavigationBackEvent} from 'lightning/flowSupport';


export default class OnboardingFlowModulePriorityScreen extends LightningElement 
{
    @api OnboardingId;
    @track modules = []

    //Get all modules related to the onboarding record by default sort order
    @wire(getAssignedModules, {OnboardingId: '$OnboardingId'})
    wiredAssets({error , data})
    {
        if(data)
        {
            let temp = [];
            
            for(let i = 0; i < data.length; i++)
            {
                let mod = {};
                mod.Id = data[i].Id;
                mod.Name = data[i].Name;
                mod.Sort_Order__c = i + 1;
                mod.Must_Complete_By__c = data[i].Must_Complete_By__c;
                mod.Hours_Required__c = data[i].Hours_Required__c;
                temp.push(mod);
            }

            this.modules = temp;
        }
        else
        {
            console.log("There was a problem retrieving the related modules");
        }
    }

    //Sort the modules by sort order
    sortOrder(module1 , module2)
    {
        if(module1.Sort_Order__c < module2.Sort_Order__c)
        {
            return -1;
        }
    }

    //Create logic for drag and drop
    drag(event){
        event.dataTransfer.setData("divId", event.target.id);
    }

    allowDrop(event){
        event.preventDefault();
    }

    drop(event){
        event.preventDefault();
        let divId = (event.dataTransfer.getData("divId")).substring(0,18);

        let currentIndex;

        //Get current index of chosen modules
        for(let i = 0; i < this.modules.length; i++)
        {
            if(this.modules[i].Id == divId)
            {
                currentIndex = i;
                break;
            }

        }

        let designatedIndex;

        let designatedId = (event.target.parentElement.parentElement.id).substring(0,18);


        //Get current index of chosen modules
        for(let i = 0; i < this.modules.length; i++)
        {
            if(this.modules[i].Id == designatedId)
            {
                designatedIndex = i;
                break;
            }

        }

        if(currentIndex > designatedIndex)
        {
            this.modules[currentIndex].Sort_Order__c = this.modules[designatedIndex].Sort_Order__c;

            for(let i = designatedIndex; i < currentIndex; i++)
            {
                this.modules[i].Sort_Order__c = this.modules[i].Sort_Order__c + 1;
            }     
        }
        else
        {
            this.modules[currentIndex].Sort_Order__c = this.modules[designatedIndex].Sort_Order__c;

            for(let i = currentIndex + 1; i <= designatedIndex; i++)
            {
                this.modules[i].Sort_Order__c = this.modules[i].Sort_Order__c - 1;
            }   
        }

        //re-sort modules
        this.modules.sort(this.sortOrder);
    }

    //Logic for previous click
    previousClick()
    {
        const backNavigationEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(backNavigationEvent);
    }

    //Create commit logic for modules that have been moved around and return new list of modules
    moduleSave()
    {
        updateModules({
            modules: this.modules
        })
        .then(result => {
            const nextNavigationEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(nextNavigationEvent);
        })
        .catch(error => {
            console.log(error.message);
        })
    }
    
}