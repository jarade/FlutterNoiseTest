package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import cachet.sensors.noisemeter.NoiseMeterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    NoiseMeterPlugin.registerWith(registry.registrarFor("cachet.sensors.noisemeter.NoiseMeterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
