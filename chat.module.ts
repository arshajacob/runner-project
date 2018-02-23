import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChatServiceService } from '../chatbot-ui/chat-service/chat-service.service';
import { ChatbotUiComponent } from '../chatbot-ui/chatbot-ui.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule

  ],
  declarations: [ChatbotUiComponent],
  exports:[ChatbotUiComponent],
  providers:[ChatServiceService]
})
export class ChatModule { }
