//
//  LiveActivityPlugin.m
//  App
//
//  Created by Dariusz Zabrzeński on 10/04/2023.
//

#import <Capacitor/Capacitor.h>

CAP_PLUGIN(LiveActivityPlugin, "LiveActivityPlugin",
           CAP_PLUGIN_METHOD(start, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(update, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(stop, CAPPluginReturnNone);
)
