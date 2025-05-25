/**
 * Lua based JSON.stringify()
 * @throws {Error}
 */
export function encode(val: any): string;

/**
 * Lua based JSON.parse()
 * @throws {Error}
 */
export function decode(str: string): any;
