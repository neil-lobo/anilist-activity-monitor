import { JSON } from ".";
import { fetch } from "./fetch";
import { debugLog, log } from "./logs";
import { settings } from "./settings";

const GQL_QUERY = `
query {
  Page(page: 1, perPage: 10) {
    pageInfo {
      currentPage
    }
    activities(
      isFollowing: true
      type: MEDIA_LIST
      hasRepliesOrTypeText: false
      sort: ID_DESC
    ) {
      ... on ListActivity {
        id
        type
        status
        progress
        createdAt
        user {
          id
          name
        }
        media {
          id
          title {
            userPreferred
          }
        }
      }
    }
  }
}
`;

export namespace ActivityItem {
  export type AnimeList = {
    type: "ANIME_LIST";
  } & (
    | {
        status: "watched episode";
        progress: string;
      }
    | {
        status: "plans to watch" | "completed";
      }
  );

  export type MangaList = {
    type: "MANGA_LIST";
  } & (
    | {
        status: "read chapter";
        progress: string;
      }
    | {
        status: "plans to read" | "completed";
      }
  );
}

export type ActivityItem = {
  id: number;
  createdAt: number;
  user: {
    name: string;
    id: number;
  };
  media: {
    id: number;
    title: {
      userPreferred: string;
    };
  };
} & (ActivityItem.AnimeList | ActivityItem.MangaList);

export type GetActivityResponse = {
  data: {
    Page: {
      pageInfo: {
        currentPage: number;
      };
      activities: ActivityItem[];
    };
  };
};

export async function getActivities(): Promise<ActivityItem[]> {
  const token = settings.getSetting("token");
  if (!token) {
    throw new Error(
      "Plugin not authenticed with Anilist. Generate a token with /anilist token get & set your token with /anilist token set"
    );
  }

  try {
    debugLog("pre fetch");
    const res = await fetch("https://graphql.anilist.co", {
      method: c2.HTTPMethod.Post,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
        Accepts: "application/json",
      },
      timeout: 5_000,
      body: JSON.stringify({ query: GQL_QUERY }),
    });
    debugLog("post fetch");

    if (res.status !== 200) {
      throw new Error(`Unsuccessful response fron AniList API (${res.status})`);
    }

    const raw = JSON.parse(res.data) as GetActivityResponse;

    return raw.data.Page.activities;
  } catch (err) {
    log("fetch err");
    log(JSON.stringify(err));
    if (err instanceof c2.HTTPResponse) {
      log("inner");
      log(err.data());
      log(err.error());
      log(err.status());
    }
    throw err;
  }
}

export function newAcitivies(
  old: ActivityItem[],
  curr: ActivityItem[]
): ActivityItem[] {
  let out: ActivityItem[] = [];

  const oldIds = new Set(old.map((a) => a.id));

  for (const activity of curr) {
    if (oldIds.has(activity.id)) break;

    out.push(activity);
  }

  return out;
}

export function constructUpdateMessage(activity: ActivityItem): string {
  const msgParts: string[] = [];

  msgParts.push(activity.user.name);
  msgParts.push(activity.status);
  if (
    activity.status === "read chapter" ||
    activity.status === "watched episode"
  ) {
    msgParts.push(activity.progress);
    msgParts.push("of");
  }
  msgParts.push(activity.media.title.userPreferred);

  const msg = msgParts.join(" ");
  return msg;
}
