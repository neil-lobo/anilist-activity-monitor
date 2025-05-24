import { fs, log, JSON, message } from "./utils";
import {
  ActivityItem,
  constructUpdateMessage,
  getActivities as getActivity,
  newAcitivies as newAcitivity,
} from "./utils/anilist";
import {
  addBroadcastChannel,
  broadcast,
  broadcastChannels,
  removeBroadcastChannel,
  syncBroadcastChannels,
} from "./utils/broadcast";
import { Command, CommandContext, CommandError } from "./utils/command";
import { clearInterval, setInterval } from "./utils/interval";

let currentActivity: ActivityItem[] | undefined;
let interval: string | undefined;
let starting = false;

const COMMAND = new Command({
  command: "anilist",
  subcommands: (parent) => [
    new Command({
      command: "token",
      parent,
      subcommands: (parent) => [
        new Command({
          parent,
          command: "get",
          action: (ctx) => {
            ctx.reply(
              "Generate authentication token at: https://anilist.co/api/v2/oauth/authorize?client_id=26560&response_type=token"
            );
          },
        }),
        new Command({
          parent,
          command: "set",
          args: ["token"],
          action: async (ctx, { token }) => {
            fs.write("token", token);

            ctx.reply("Token set!");

            await startup();
          },
        }),
      ],
    }),
    new Command({
      parent,
      command: "broadcast",
      subcommands: (parent) => [
        new Command({
          parent,
          command: "add",
          args: ["channel"],
          action: (ctx, { channel }) => {
            addBroadcastChannel(channel);
            ctx.reply(`Added ${channel} to broadcast list`);
          },
        }),
        new Command({
          parent,
          command: "remove",
          args: ["channel"],
          action: (ctx, { channel }) => {
            removeBroadcastChannel(channel);

            ctx.reply(`Removed ${channel} from broadcast list`);
          },
        }),
        new Command({
          parent,
          command: "list",
          action: (ctx) => {
            ctx.reply(
              `Broadcast channels: ${Array.from(broadcastChannels)
                .map((c) => c.get_name())
                .join(", ")}`
            );
          },
        }),
      ],
    }),
    new Command({
      parent,
      command: "status",
      action: async (ctx) => {
        try {
          await getActivity();
          ctx.reply("Status: Connected");
        } catch (err) {
          ctx.reply(`Error: ${(err as Error).message}`);
        }
      },
    }),
    new Command({
      parent,
      command: "commands",
      action: (ctx) => {
        ctx.reply(
          `Available commands: ${parent.availableCommands().join(", ")}`
        );
      },
    }),
  ],
});

async function startup() {
  starting = true;
  try {
    log("Loading activities...");
    currentActivity = await getActivity();
    log("Loaded activities");

    if (interval) {
      clearInterval(interval);
    }

    interval = setInterval(async () => {
      try {
        // get updates
        const newAct = await getActivity();
        const updates = newAcitivity(currentActivity!, newAct);
        currentActivity = newAct;

        // log in reverse order
        updates.reverse();

        for (const activity of updates) {
          // construct update message
          const msg = constructUpdateMessage(activity);

          // broadcast message
          broadcast(msg);
        }
      } catch (err) {
        log(JSON.stringify(err));
        broadcast((err as Error).message);
        if (interval) {
          clearInterval(interval);
        }
      }
      // }, 10_000);
    }, 30_000 /* every 30s */);

    broadcast("Loaded");
  } finally {
    starting = false;
  }
}

function registerEvents() {
  c2.register_command("/anilist", (ctx) => {
    function reply(_message: string) {
      ctx.channel.add_system_message(message(_message));
    }

    if (starting) {
      reply("Plugin starting up...");
      return;
    }

    const args = ctx.words;
    args.shift();

    const _ctx: CommandContext = {
      ...ctx,
      reply,
    };

    COMMAND.run(_ctx, args).catch((err) => {
      log(JSON.stringify(err));

      if (err instanceof CommandError) {
        reply(`Command error: ${err.message}`);
      } else {
        log("unexpected error:");
        log(JSON.stringify(err));
        reply(`Unexpected error: ${(err as Error).message}`);
      }
    });
  });

  c2.register_callback(c2.EventType.CompletionRequested, (event) => {
    if (
      event.is_first_word &&
      `/${COMMAND.params.command}`.startsWith(event.query)
    ) {
      return {
        values: [`/${COMMAND.params.command} `],
        hide_others: false,
      };
    }

    if (
      event.full_text_content.split(" ")[0] !== `/${COMMAND.params.command}`
    ) {
      return {
        hide_others: false,
        values: [],
      };
    }

    const chain = event.full_text_content
      .trimEnd()
      .slice(1)
      .split(" ")
      .slice(1, -1);

    /*
    Need to traverse this tree following `chain`. If `chain` is not completely consumed, there is no autocomplete.
    If `chain` *is* consumed, attempt to match `event.query` with the next possible subcommand names

          anilist
          /      \
      token      broadcast
      /   \      /     \
    get   set  add    remove
    
    */

    let curr: Command = COMMAND;
    for (const _command of chain) {
      let availableCommands;
      try {
        availableCommands = curr.availableCommands();
      } catch (err) {
        return {
          values: [],
          hide_others: false,
        };
      }

      if (availableCommands.includes(_command)) {
        if ("subcommands" in curr.params) {
          const c = curr.params
            .subcommands(curr)
            .find((c) => c.params.command === _command);

          if (!c) {
            // this should be unreachable
            throw new Error("assert failed");
          }

          curr = c;
        } else {
          // this should be unreachable
          throw new Error("assert failed");
        }
      } else {
        return {
          values: [],
          hide_others: false,
        };
      }
    }

    try {
      for (const _command of curr.availableCommands()) {
        if (_command.startsWith(event.query)) {
          return {
            values: [`${_command} `],
            hide_others: false,
          };
        }
      }
    } catch (err) {
      log("no more subcommands to complete");
    }

    return {
      values: [],
      hide_others: false,
    };
  });
}

syncBroadcastChannels();
registerEvents();
startup().catch((err) => {
  log(JSON.stringify(err));
  broadcast(`Error: ${(err as Error).message}`);
});
