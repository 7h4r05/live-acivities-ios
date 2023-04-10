import { CommonModule } from "@angular/common";
import { ChangeDetectionStrategy, Component, Input } from "@angular/core";
import { RouterLink } from "@angular/router";
import { IonicModule } from "@ionic/angular";
import { Message } from "../services/data.service";
import { LiveActivityPluginService } from "../services/live-activity-plugin.service";

@Component({
  selector: "app-message",
  templateUrl: "./message.component.html",
  styleUrls: ["./message.component.scss"],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
  imports: [CommonModule, IonicModule, RouterLink],
})
export class MessageComponent {
  @Input() message?: Message;

  constructor(private liveActivityPluginService: LiveActivityPluginService) {}

  async start(item: Message) {
    const activityId = await this.liveActivityPluginService.start({
      distance: item.distance,
      expectedTimeInMinutes: item.expectedTimeInMinutes,
      title: item.title,
    });
    let distance = item.distance;
    let expectedTimeInMinutes = item.expectedTimeInMinutes;
    let interval = setInterval(async () => {
      distance -= 1000;
      expectedTimeInMinutes -= 1;
      if (distance > 0) {
        await this.liveActivityPluginService.update({
          activityId,
          distance,
          expectedTimeInMinutes,
        });
      } else {
        clearInterval(interval);
        await this.liveActivityPluginService.stop({
          activityId,
        });
      }
    }, 3000);
  }
}
