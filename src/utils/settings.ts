import { fs, JSON } from ".";

class Settings<K> {
  initialized: boolean;
  keys: Partial<K>;

  constructor() {
    this.initialized = false;
    this.keys = {};

    this.init();
    this.loadSettings();
  }

  /**
   * Write empty settings file if there is none found
   */
  private init() {
    try {
      fs.read("settings.json");
    } catch (err) {
      fs.write("settings.json", "{}");
    }
  }

  /**
   * Get setting from key. Returns a copy of it's value
   * @param key Setting key
   * @returns Copy of setting value
   */
  getSetting<T extends keyof typeof this.keys>(key: T): (typeof this.keys)[T] {
    return Object.assign({}, this.keys[key]);
  }

  /**
   * Set setting by key
   * @param key Setting key
   * @param value Setting value
   * @throws
   */
  setSetting<T extends keyof typeof this.keys>(
    key: T,
    value: Exclude<(typeof this.keys)[T], undefined>
  ) {
    const preVal = this.keys[key];

    try {
      this.keys[key] = value;

      this.flushSettings();
    } catch (err) {
      this.keys[key] = preVal;
      throw err;
    }
  }

  /**
   * Load settings file into object
   */
  loadSettings() {
    try {
      this.keys = JSON.parse(fs.read("settings.json"));
    } catch (err) {
      this.keys = {};
    }
  }

  /**
   * Write settings object to disk
   * @throws
   */
  flushSettings() {
    fs.write("settings.json", JSON.stringify(this.keys));
  }
}

export const settings = new Settings<{
  token: string;
  broadcastChannels: string[];
}>();
