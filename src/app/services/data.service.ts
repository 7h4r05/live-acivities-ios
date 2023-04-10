import { Injectable } from "@angular/core";

export interface Message {
  title: string;
  distance: number;
  expectedTimeInMinutes: number;
}

@Injectable({
  providedIn: "root",
})
export class DataService {
  public messages: Message[] = [
    {
      title: "Knowledge delivery",
      distance: 9000,
      expectedTimeInMinutes: 20,
    },
    {
      title: "Grocery picker",
      distance: 11000,
      expectedTimeInMinutes: 25,
    },
  ];

  constructor() {}

  public getMessages(): Message[] {
    return this.messages;
  }

  public getMessageById(id: number): Message {
    return this.messages[id];
  }
}
