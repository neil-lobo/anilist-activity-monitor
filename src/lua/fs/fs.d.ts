/**
 * Lua fs.read()
 * @throws {Error}
 */
export function read(filename: string): string;

/**
 * Lua fs.write()
 * @throws {Error}
 */
export function write(filename: string, data: string): void;
