import { debugLog as debug } from "./logs";

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
  debug("create");
  const req = c2.HTTPRequest.create(options.method, url);

  debug("headers");
  for (const [k, v] of Object.entries(options.headers ?? {})) {
    req.set_header(k, v);
  }

  debug("timeout");
  if (options.timeout) {
    req.set_timeout(options.timeout);
  }

  debug("body");
  if (options.body) {
    req.set_payload(options.body);
  }

  debug("promise");
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
