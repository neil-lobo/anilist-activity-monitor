import { fs, message } from ".";
import { CommandError } from "./command";
import { settings } from "./settings";

// TODO: jsdoc

export const broadcastChannels: Set<c2.Channel> = new Set();

function getBroadcastChannels(): Set<c2.Channel> {
  const channels: Set<c2.Channel> = new Set();

  (settings.getSetting("broadcastChannels") ?? []).forEach((c) => {
    const _channel = c2.Channel.by_name(c);
    if (!_channel) return;

    channels.add(_channel);
  });

  return channels;
}

export function syncBroadcastChannels() {
  let channels: Set<c2.Channel> = new Set();
  try {
    channels = channels.union(getBroadcastChannels());
  } catch (err) {}

  broadcastChannels.clear();
  for (const channel of channels) {
    broadcastChannels.add(channel);
  }
}

export function addBroadcastChannel(channelName: string) {
  channelName = channelName.toLowerCase();

  const channel = c2.Channel.by_name(channelName);
  if (!channel) {
    throw new CommandError(
      "Channel must be opened in chatterino to be added as a broadcast channel"
    );
  }

  const channelNames = Array.from(broadcastChannels).map((c) => c.get_name());

  if (channelNames.includes(channelName)) {
    throw new CommandError("Channel is already a broadcast channel");
  }

  broadcastChannels.add(channel);
  channelNames.push(channelName);

  try {
    settings.setSetting("broadcastChannels", channelNames);
  } catch (err) {
    broadcastChannels.delete(channel);
    throw err;
  }
}

export function removeBroadcastChannel(channelName: string) {
  channelName = channelName.toLowerCase();

  let channel: c2.Channel | undefined;

  for (const _channel of broadcastChannels) {
    if (_channel.get_name() === channelName) {
      channel = _channel;
    }
  }

  if (!channel) {
    throw new CommandError("Channel is not a broadcast channel");
  }

  broadcastChannels.delete(channel);
  const channelNames = Array.from(broadcastChannels).map((c) => c.get_name());

  try {
    settings.setSetting("broadcastChannels", channelNames);
  } catch (err) {
    broadcastChannels.add(channel);
  }
}

export function broadcast(_message: string) {
  for (const channel of broadcastChannels) {
    channel.add_system_message(message(_message));
  }
}
