import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChatbotUiComponent } from './chatbot-ui.component';

describe('ChatbotUiComponent', () => {
  let component: ChatbotUiComponent;
  let fixture: ComponentFixture<ChatbotUiComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChatbotUiComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChatbotUiComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
