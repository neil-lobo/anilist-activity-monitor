import { read, write } from "../lua/fs/fs";
import { decode, encode } from "../lua/json/json";

export function randomId(length: number) {
  const digits = [];
  for (let i = 0; i < length; i++) {
    digits.push(Math.floor(Math.random() * 16).toString(16));
  }
  return digits.join("");
}

export function log(...data: any) {
  c2.log(c2.LogLevel.Debug, ...data);
}

export function message(msg: string): string {
  return `[AniList] ${msg}`;
}

// TODO: pure JS impl
// in the lua impl, encode('{}') results in '[]'
export const JSON = {
  stringify: encode,
  parse: decode,
};

export class HTTPResponse {
  data: string;
  error: string;
  status: number | null;

  constructor(data: string, error: string, status: number | null) {
    (this.data = data), (this.error = error), (this.status = status);
  }
}

export async function fetch(
  url: string,
  options: {
    method: c2.HTTPMethod;
    headers?: { [k: string]: string };
    timeout?: number;
    body?: string;
  } = { method: c2.HTTPMethod.Get }
): Promise<HTTPResponse> {
  const req = c2.HTTPRequest.create(options.method, url);

  for (const [k, v] of Object.entries(options.headers ?? {})) {
    req.set_header(k, v);
  }

  if (options.timeout) {
    req.set_timeout(options.timeout);
  }

  if (options.body) {
    req.set_payload(options.body);
  }

  return new Promise((res) => {
    req.on_error((response) =>
      res({
        data: response.data(),
        error: response.error(),
        status: response.status(),
      })
    );
    req.on_success((response) =>
      res({
        data: response.data(),
        error: response.error(),
        status: response.status(),
      })
    );
    req.execute();
  });
}

export const fs = {
  read: read,
  write: write,
};
