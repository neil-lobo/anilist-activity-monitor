import { settings } from "./settings";

export function log(...data: any) {
  c2.log(c2.LogLevel.Debug, ...data);
}

export function debugLog(...data: any) {
  const debug = settings.getSetting("debug");

  if (debug) {
    log("< DEBUG >", ...data);
  }
}
