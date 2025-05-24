import { fs, JSON } from ".";

export function log(...data: any) {
  c2.log(c2.LogLevel.Debug, ...data);
}

export function debugLog(...data: any) {
  const settings = JSON.parse(fs.read("settings.json"));

  if (settings.debug) {
    log("< DEBUG >", ...data);
  }
}
