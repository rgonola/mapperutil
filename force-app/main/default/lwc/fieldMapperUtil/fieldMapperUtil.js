import { LightningElement,api,track } from 'lwc';
import { sendCustomevent } from 'c/util';

export default class FieldMapperUtil extends LightningElement {
		
		@api index;
		@api sourceValue ;
		@api destinationValue ;
		@api sourceOptions ;
		@api destinationOptions ;
		
		@track items;
		
		@api
    get itemList() {
        return this.items;
    }
    set itemList(value) {
        this.items = [...value];
				
				if(this.items && this.items[this.index] && this.items[this.index].sourceValue) this.sourceValue = this.items[this.index].sourceValue;
				if(this.items && this.items[this.index] && this.items[this.index].destinationValue) this.destinationValue = this.items[this.index].destinationValue;
    }
		
		get isfirstrow() {
        return this.index > 0 ? true : false;
    }
		
		handlesourceChange(event) {
        this.sourceValue = event.target.value;
				var currentrow = {...this.items[this.index]};
				currentrow.sourceValue = event.target.value;
				if(this.destinationValue) currentrow.destinationValue = this.destinationValue;
				
				this.items.splice(this.index, 1, currentrow);
				
				sendCustomevent(this,"mappingresults",this.itemList);
    }
		
		handledestinationChange(event) {
        this.destinationValue = event.target.value;
				let currentrow = {...this.items[this.index]};
				currentrow.destinationValue = event.target.value;
				currentrow.sourceValue = this.sourceValue;
				
				this.items.splice(this.index, 1, currentrow);
				
				sendCustomevent(this,"mappingresults",this.itemList);
    }
		
		removeRow() {
				console.log(this.index);
        if (this.index >= 1) {
						
						let newlst =[];
						
						for (var i = 0, len = this.items.length; i < len; i++) {  
								if(i === this.index){

								}else if(i < this.index){
										
										let arayel = {...this.items[i]};
										newlst.push(arayel);
										
								}else if(i > this.index){

										this.sourceValue = '';	
										const val = this.items[i].id - 1;
										let arayel = {...this.items[i]};
										arayel.id = val;
										newlst.push(arayel);
										
								}
						}
								
						
						this.items =[...newlst] ;
            
						sendCustomevent(this,"mappingresults",this.itemList);
        }
    }
		addRow() {
				
        let neval = this.itemList.length ;
				
        var newItem = [{ "id": neval }];
        this.itemList = this.itemList.concat(newItem);
				
				sendCustomevent(this,"mappingresults",this.itemList);
    }
		
		
}