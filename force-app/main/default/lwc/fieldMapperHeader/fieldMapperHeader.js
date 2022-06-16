import { LightningElement,api,track } from 'lwc';
import getFields from '@salesforce/apex/FieldMapperController.getfieldsfromapi';
import saveMapping from '@salesforce/apex/FieldMapperController.saverecord';
import { showToast } from 'c/util';

export default class FieldMapperHeader extends LightningElement {
		
		@api sourceObject ;
		@api destinationObject ;
		@api sourceObjects ;
		@api destinationObjects ;
		
		@track responseList =[
        {
            id: 0
        }
    ];
		
		@track showMapping ;
		@track sourceObjReq = true;
		@track isLoading = false;
		@track _sourceOptions =[];
		@track _destinationOptions =[];
		
		
		connectedCallback(){
				
				this.sourceObjects = [{label: 'TAA_Sales_Pulse_By_User__c', value: 'TAA_Sales_Pulse_By_User__c'}];
		    this.destinationObjects = [{label: 'Sales_Report_Card__c', value: 'Sales_Report_Card__c'}];
				
		}
		
		handleCancel() {
        this.sourceObject = '';
		    this.destinationObject = '';
				this.showMapping = false;
    }
		
		handleSubmit() {
				
				if(this.responseList && this.responseList[0].sourceValue && this.responseList[0].destinationValue){
						this.isLoading = true;
						console.log(JSON.stringify(this.responseList));
						const req = { recordLst: this.responseList,Sourceobj: this.sourceObject,Destinationobj: this.destinationObject };
						
						saveMapping(req)
            .then(result => {
								
								if(result){
										this.responseList = result;
										showToast(this,'Mapping saved successfully!','Success!','success');
								}
								
								
								
                this.isLoading = false;
								
								this.showMapping = true;
            })
            .catch(error => {
                //this.error = error;
                this.isLoading = false;
								showToast(this,error,'Error','error')
            });

				}else{
						showToast(this,'Nothing to save','Error','error')
				}
    }
		
		sourceObjectChange(event) {
        this.sourceObject = event.target.value;
				if(this.sourceObject){
						
						this.sourceObjReq = false;
						
				}
    }
		
		destinationObjectChange(event) {
        this.destinationObject = event.target.value;
				if(this.destinationObject){
						this.isLoading = true;
						
						const req = { srcobj: this.sourceObject,destinatnobj: this.destinationObject };
						
						getFields(req)
            .then(result => {
								
								if(result.fldmapping && result.fldmapping.length > 0){
										this.responseList = result.fldmapping;
								}
								
								
								if(result.fieldskeywithApi){
										for (let key in result.fieldskeywithApi) {
											  this._sourceOptions.push({value:result.fieldskeywithApi[key], label:key});
										}
								}
								
								if(result.dstnfieldskeywithApi){
										for (let key in result.dstnfieldskeywithApi) {
											  this._destinationOptions.push({value:result.dstnfieldskeywithApi[key], label:key});
										}
								}
								
								
                this.isLoading = false;
								this.showMapping = true;
            })
            .catch(error => {
                //this.error = error;
                this.isLoading = false;
								showToast(this,error,'error','error')
            });

						
						
				}
    }
		handlemappingchange(event){
				
				this.responseList = event.detail;
				
				
		}
		
		
}