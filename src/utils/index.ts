import { read, write } from "../lua/fs/fs";
import { decode, encode } from "../lua/json/json";

export function randomId(length: number) {
  const digits = [];
  for (let i = 0; i < length; i++) {
    digits.push(Math.floor(Math.random() * 16).toString(16));
  }
  return digits.join("");
}

export function message(msg: string): string {
  return `[AniList] ${msg}`;
}

// TODO: pure JS impl
// in the lua impl, encode('{}') results in '[]'
export const JSON = {
  /**
   * @throws {Error}
   */
  stringify: encode,
  /**
   * @throws {Error}
   */
  parse: decode,
};

export const fs = {
  /**
   * @throws {Error}
   */
  read: read,
  /**
   * @throws {Error}
   */
  write: write,
};
