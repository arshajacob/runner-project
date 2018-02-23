import { Injectable, OnInit } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import 'rxjs/add/operator/map';
import { environment } from '../../../environments/environment';
import { ApiAiClient } from 'api-ai-javascript';
import { Observable } from 'rxjs/Observable';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

export class Message {
  constructor(public content: string, public sentBy: string) {
   
  }
}


@Injectable()
export class ChatServiceService {

 private _url = 'https://api.myjson.com/bins/x3d6l';
  // private baseUrl = "https://api.api.ai/api/";
  // private accessToken = "4569fe09e36f4dbda59559a3e213c9af";
  // private path: string;
  constructor(private _http: Http) { }
  getData() {
    return this._http.get(this._url)
    .map((response: Response) => response.json());
  }
  

  // postData(input: any) {
  //   this.path = 'query?v=20150910';

  //   let headers = new Headers({ 'Authorization': 'Bearer ' + this.accessToken });
  //   let options = new RequestOptions({ headers: headers });



    // let headers = new Headers({
    //   'Authorization': 'Bearer ' + this.accessToken,
    //   'Content-Type': 'application/json;charset=utf-8'
    // });
  //   return this._http
  //     .post(this.baseUrl + this.path, input, options)
  //     .map((response: Response) => response.json());
  // }
}


//   readonly token = environment.dialogflow.angularBot;
//   readonly client = new ApiAiClient({ accessToken: this.token });
//   conversation = new BehaviorSubject<Message[]>([]);

//   constructor() {

//   }
  
//    converse(msg: string, prsn: string) {
     
     
//     if (prsn==='bot'){
//       const speech = 'Hi, Welcome to EQ_Chatbot. How can I help you?';
//       const botMessage = new Message(speech, 'bot');
//       this.update(botMessage);
//     }
//    else{
//         const userMessage = new Message(msg, 'user');
//         this.update(userMessage);
//         return this.client.textRequest(msg)
//                .then(res => {
//                   const speech = res.result.fulfillment.speech;
//                    const botMessage = new Message(speech, 'bot');
//                   this.update(botMessage);
//                });
//      }
       
//    }
    
//     update(msg: Message) {
//       this.conversation.next([msg]);
//     }
// }

// var accessToken = "4569fe09e36f4dbda59559a3e213c9af";
// 		var baseUrl = "https://api.api.ai/api/"; 

// var text = $("#input").val();
// 			$.ajax({
// 				type: "POST",
// 				url: baseUrl + "query?v=20150910",
// 				contentType: "application/json; charset=utf-8",
// 				dataType: "json",
// 				headers: {
// 					"Authorization": "Bearer " + accessToken
// 				},
// 				data: JSON.stringify({ query: text, lang: "en", sessionId: "somerandomthing" }),
// 				success: function(data) {
// 					setResponse(JSON.stringify(data, undefined, 2));
// 				},
// 				error: function() {
// 					setResponse("Internal Server Error");
// 				}
// 			});
// 			setResponse("Loading..."); 