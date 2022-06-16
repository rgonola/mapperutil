import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


function	 showToast(cmp,msg,title,varnt) {
		const event = new ShowToastEvent({
				title: title,
				message: msg,
				variant: varnt,
				messageData: [
						/*'Salesforce',
								{
										url,
										label: 'here',
								},*/
				],
		});
		cmp.dispatchEvent(event);
}

function	 sendCustomevent(cmp,eventname,req) {
		const listrs = new CustomEvent(eventname,{detail:req});
		cmp.dispatchEvent(listrs);
}

export { showToast }
export { sendCustomevent }