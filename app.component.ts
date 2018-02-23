import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';
  showId: boolean;
  constructor(){
    this.showId = false;
  }
  toggle(){
    this.showId=!this.showId;
    }
}
