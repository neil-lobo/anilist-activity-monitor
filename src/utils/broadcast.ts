import { message } from ".";
import { CommandError } from "./command";
import { settings } from "./settings";

// TODO: jsdoc

/**
 * @throws {CommandError}
 * @throws {Error}
 */
export function addBroadcastChannel(channelName: string) {
  channelName = channelName.toLowerCase();

  const channel = c2.Channel.by_name(channelName);
  if (!channel || !channel.is_valid()) {
    throw new CommandError(
      "Channel must be opened in chatterino to be added as a broadcast channel"
    );
  }

  const channels = settings.getSetting("broadcastChannels") ?? [];

  if (channels.includes(channelName)) {
    throw new CommandError("Channel is already a broadcast channel");
  }

  channels.push(channelName);
  settings.setSetting("broadcastChannels", channels);
}

/**
 * @throws {CommandError}
 * @throws {Error}
 */
export function removeBroadcastChannel(channelName: string) {
  channelName = channelName.toLowerCase();

  const channels = new Set(settings.getSetting("broadcastChannels") ?? []);
  if (!channels.has(channelName)) {
    throw new CommandError(
      "Channel is not a broadcast channel. Use `/anilist broadcast list` to see current broadcast channels"
    );
  }

  channels.delete(channelName);

  settings.setSetting("broadcastChannels", Array.from(channels));
}

export function broadcast(_message: string) {
  const channels = settings.getSetting("broadcastChannels") ?? [];

  for (const channelName of channels) {
    const channel = c2.Channel.by_name(channelName);
    if (!channel || !channel.is_valid()) {
      continue;
    }

    channel.add_system_message(message(_message));
  }
}
