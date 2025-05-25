import { JSON } from ".";
import { log } from "./logs";

export class CommandError extends Error {
  extraMessages: string[];
  constructor(message?: string, extraMessages?: string[]) {
    super(message);
    this.extraMessages = extraMessages ?? [];
  }
}

export type CommandReply = {
  reply(_message: string): void;
};

export type CommandContext = c2.CommandContext & CommandReply;

export type CommandParams = {
  command: string;
  parent?: Command;
  // TODO: aliases?
} & (
  | {
      subcommands: (parent: Command) => Command[];
    }
  | {
      args?: string[];
      /**
       * @throws {CommandError}
       * @throws {Error}
       */
      action: (
        ctx: CommandContext,
        args: { [k: string]: string }
      ) => void | Promise<void>;
    }
);

export class Command {
  params: CommandParams;
  constructor(params: CommandParams) {
    this.params = params;
  }

  /**
   * @throws {CommandError}
   * @throws {Error}
   */
  async run(ctx: CommandContext, args: string[]) {
    if ("subcommands" in this.params) {
      if (args.length === 0) {
        throw new CommandError(
          `Missing command. Available commands: ${this.availableCommands().join(
            ", "
          )}`,
          [`Usage: ${this.usage()} <command>`]
        );
      }

      const subcommand = this.params
        .subcommands(this)
        .find((c) => c.params.command === args[0]);
      if (!subcommand) {
        throw new CommandError(`Unknown command: ${args[0]}`);
      }

      const _args = [...args];
      _args.shift();

      await subcommand.run(ctx, _args);
    } else {
      const keys = this.params.args ?? [];
      const vals = [...args];

      if (keys.length != vals.length) {
        log("args length mismatch");
        log(JSON.stringify(this.getCommandChain()));
        throw new CommandError(this.usage());
      }

      let _args: { [k: string]: string } = {};
      for (let i = 0; i < keys.length; i++) {
        _args[keys[i]] = vals[i];
      }

      await this.params.action(ctx, _args);
    }
  }

  getCommandChain(): string[] {
    if (!this.params.parent) {
      return [this.params.command];
    } else {
      return [...this.params.parent.getCommandChain(), this.params.command];
    }
  }

  /**
   * @throws {Error}
   */
  availableCommands(): string[] {
    if ("subcommands" in this.params) {
      return this.params.subcommands(this).map((c) => c.params.command);
    } else {
      // unexpected error
      throw new Error("Command has no subcommands");
    }
  }

  usage() {
    let usage = "/";

    const chain = this.getCommandChain();
    usage += chain.join(" ");
    if ("args" in this.params && this.params.args) {
      usage += " ";
      usage += this.params.args.map((a) => `<${a}>`).join(" ");
    }

    return usage;
  }
}
