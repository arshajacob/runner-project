import { Component, OnInit } from '@angular/core';
import { ChatServiceService, Message } from './chat-service/chat-service.service';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/scan';

@Component({
  selector: 'app-chatbot-ui',
  templateUrl: './chatbot-ui.component.html',
  styleUrls: ['./chatbot-ui.component.css'],
  providers:[ChatServiceService]
})
export class ChatbotUiComponent implements OnInit {
  listData = [];
  uinput : string;
  dialog : string = "";
  stimulus: string;
  response: string;
  sources = [];
  showId: boolean;
   
  constructor(private _newService: ChatServiceService) {
    
   }
  ngOnInit() {
    
    this._newService.getData()
        .subscribe(resListData => {
          /*this.listData= resListData;*/
          console.log(resListData);
        });
       
        
      // this._newService.postData('hello')
      //   .subscribe(resListData => {
      //     this.listData= resListData;
      //     console.log(resListData);
      //   });
      //   // this._newService.postData('hello')
      //   // .subscribe(resListData => {
      //   //   this.listData= resListData;
      //   // });
      
        this.showId = false;
        this.sources = [{"msg":"Welcome,I'm EQ BOT,How may I help you?", "type":"output"}];
  }
  onKey(event: any) { 
        if (event.keyCode == 13){
         
          this.uinput= event.target.value;
          this.sources.push({ 'msg': this.uinput, 'type': 'user' });
          this.dialog = this.dialog + ">> " + this.uinput +  '\r' + "\n";
          //this.chatbot();
          this.dialog = this.dialog  +  '\r' + "\n";
          this.response = this.dialog;
          this.stimulus = "";
          
        }
    
  }
  toggle(){
    this.showId=!this.showId;
    }
  
    chatbot() {
    let i: number = 0;
    let soutput;
    let date = this.formatAMPM(new Date());
    for (i = 0; i < this.listData.length; i++) {
      let re = new RegExp(this.listData[i][0], "i");
      if (re.test(this.uinput)) {
        let len = this.listData[i].length - 1;
        let index = Math.ceil(len * Math.random());
        let reply = this.listData[i][index];
        if (/\$\d/.test(reply)) {
          soutput = this.uinput.replace(re, reply);
        }
        else {
          soutput = reply;
        }
        soutput = soutput.substr(0, 1).toUpperCase() + soutput.substr(1);
        this.sources.push({ 'msg': soutput, 'type': 'output','date':date });
        this.dialog = this.dialog + "<< " + soutput + '\r' + "\n";
        break;
      }
    }
  }
  formatAMPM(date) {
    let hours = date.getHours();
    let minutes = date.getMinutes();
    let ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0'+minutes : minutes;
    let strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
} 
}




/*observable code*/
//     messages: Observable<Message[]>;
//     formValue: string;
//      showId: boolean;
//     constructor(private _newService: ChatServiceService) {
       
//     }

//      ngOnInit() {
//       this.messages = this._newService.conversation.asObservable()
//         .scan((acc, val) => acc.concat(val) );
//       this.showId = false;
//       this._newService.converse('','bot');

//      }
//     sendMessage() {
//       event.preventDefault();
//         this._newService.converse(this.formValue,'user');

//         this.formValue = '';
     
//       // this._newService.converse(this.formValue,'user');
      
//     }
//     toggle(){
//       this.showId=!this.showId;
//       this._newService.converse('','bot');
//     }
//     refresh(){
//       this.messages=null;
//       this.messages = this._newService.conversation.asObservable()
//         .scan((acc, val) => acc.concat(val) );
//       this._newService.converse('','bot');
//     }
//     toggleMinimize(){
//       this.showId=!this.showId;
//       this.messages = this._newService.conversation.asObservable()
//         .scan((acc, val) => acc.concat(val) );
//         this._newService.converse('','bot');
//     }
// }
  




