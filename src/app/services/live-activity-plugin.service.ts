import { Injectable } from "@angular/core";
import { Capacitor, registerPlugin } from "@capacitor/core";

const _pluginName: string = "LiveActivityPlugin";

export interface LiveActivityStartParams {
  title: string;
  distance: number;
  expectedTimeInMinutes: number;
}

export interface LiveActivityUpdateParams {
  distance: number;
  activityId: string;
  expectedTimeInMinutes: number;
}

export interface LiveActivityStopParams {
  activityId: string;
}

export interface LiveActivityPlugin {
  start(params: LiveActivityStartParams): Promise<{ activityId: string }>;
  update(params: LiveActivityUpdateParams): Promise<void>;
  stop(params: LiveActivityStopParams): Promise<void>;
}
const LiveAcivityPlugin = registerPlugin<LiveActivityPlugin>(_pluginName);

@Injectable({
  providedIn: "root",
})
export class LiveActivityPluginService {
  async start(params: LiveActivityStartParams): Promise<string> {
    if (Capacitor.isPluginAvailable(_pluginName)) {
      return (await LiveAcivityPlugin.start(params))?.activityId;
    }
    throw Error();
  }
  async update(params: LiveActivityUpdateParams): Promise<void> {
    if (Capacitor.isPluginAvailable(_pluginName)) {
      return await LiveAcivityPlugin.update(params);
    }
  }
  async stop(params: LiveActivityStopParams): Promise<void> {
    if (Capacitor.isPluginAvailable(_pluginName)) {
      await LiveAcivityPlugin.stop(params);
    }
  }
}
