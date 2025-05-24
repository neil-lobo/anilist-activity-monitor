import { fs, message } from ".";

export const broadcastChannels: Set<c2.Channel> = new Set();

function getBroadcastChannels(): Set<c2.Channel> {
  const channels: Set<c2.Channel> = new Set();

  const raw = fs.read("channels");
  raw
    .split("\n")
    .map((c) => c.trim())
    .filter((c) => c !== "")
    .forEach((c) => {
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

function flushBroadcastChannels() {
  fs.write(
    "channels",
    Array.from(broadcastChannels)
      .map((c) => c.get_name())
      .join("\n")
  );
}

export function addBroadcastChannel(channelName: string): boolean {
  const channel = c2.Channel.by_name(channelName);
  if (!channel) return false;
  broadcastChannels.add(channel);

  try {
    flushBroadcastChannels();
  } catch (err) {
    broadcastChannels.delete(channel);
    return false;
  }

  return true;
}

export function removeBroadcastChannel(channelName: string) {
  let channel: c2.Channel | undefined;

  for (const _channel of broadcastChannels) {
    if (_channel.get_name() === channelName) {
      channel = _channel;
    }
  }

  if (!channel) {
    return;
  }

  broadcastChannels.delete(channel);

  try {
    flushBroadcastChannels();
  } catch (err) {
    broadcastChannels.add(channel);
  }
}

export function broadcast(_message: string) {
  for (const channel of broadcastChannels) {
    channel.add_system_message(message(_message));
  }
}
