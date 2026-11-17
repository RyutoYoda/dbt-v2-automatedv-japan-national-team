#!/usr/bin/env python3
"""Download a small Japan World Cup sample from StatsBomb Open Data."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from urllib.request import urlopen

ROOT = Path(__file__).resolve().parents[1]
SEASONS = ((106, "2022"),)
BASE_URL = "https://raw.githubusercontent.com/hudl/open-data/master/data"


def read_json(url: str):
    with urlopen(url, timeout=60) as response:
        return json.load(response)


def write_csv(path: Path, rows: list[dict], columns: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=columns, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def position_name(player: dict) -> str:
    positions = player.get("positions") or []
    if not positions:
        return "Unknown"
    position = positions[0].get("position", "Unknown")
    if isinstance(position, dict):
        return position.get("name", "Unknown")
    return position or "Unknown"


def main() -> None:
    matches: list[dict] = []
    lineups: list[dict] = []
    shots: list[dict] = []
    player_names: dict[str, str] = {}

    for season_id, season_name in SEASONS:
        season_matches = read_json(f"{BASE_URL}/matches/43/{season_id}.json")
        japan_matches = [
            match
            for match in season_matches
            if "Japan" in (match["home_team"]["home_team_name"], match["away_team"]["away_team_name"])
        ]
        if not japan_matches:
            raise RuntimeError(f"No Japan matches found in FIFA World Cup {season_name}")

        for match in japan_matches:
            match_id = int(match["match_id"])
            match_date = match["match_date"]
            loaded_at = match.get("last_updated") or f"{match_date}T00:00:00"
            home = match["home_team"]
            away = match["away_team"]
            matches.append(
                {
                    "match_id": match_id,
                    "season_id": season_id,
                    "season_name": season_name,
                    "match_date": match_date,
                    "kick_off": match.get("kick_off"),
                    "competition_id": 43,
                    "competition_name": "FIFA World Cup",
                    "home_team_id": home["home_team_id"],
                    "home_team_name": home["home_team_name"],
                    "home_score": match.get("home_score"),
                    "away_team_id": away["away_team_id"],
                    "away_team_name": away["away_team_name"],
                    "away_score": match.get("away_score"),
                    "stage_name": (match.get("competition_stage") or {}).get("name", "Unknown"),
                    "stadium_name": (match.get("stadium") or {}).get("name", "Unknown").strip(),
                    "record_source": "statsbomb_open_data",
                    "loaded_at": loaded_at,
                }
            )

            lineup_data = read_json(f"{BASE_URL}/lineups/{match_id}.json")
            for team in lineup_data:
                for player in team.get("lineup", []):
                    player_id = str(player["player_id"])
                    player_name_value = player.get("player_name", "Unknown")
                    player_names[player_id] = player_name_value
                    positions = player.get("positions") or []
                    first_position = positions[0] if positions else {}
                    position_from = first_position.get("from")
                    lineups.append(
                        {
                            "match_id": match_id,
                            "season_name": season_name,
                            "match_date": match_date,
                            "team_id": team.get("team_id"),
                            "team_name": team.get("team_name"),
                            "player_id": player_id,
                            "player_name": player_name_value,
                            "jersey_number": player.get("jersey_number"),
                            "position_name": position_name(player),
                            "is_starter": str(position_from or "").startswith("00:00"),
                            "record_source": "statsbomb_open_data",
                            "loaded_at": loaded_at,
                        }
                    )

            event_data = read_json(f"{BASE_URL}/events/{match_id}.json")
            for event in event_data:
                if (event.get("type") or {}).get("name") != "Shot":
                    continue
                shot = event.get("shot") or {}
                team = event.get("team") or {}
                player = event.get("player") or {}
                shots.append(
                    {
                        "event_id": event["id"],
                        "match_id": match_id,
                        "period": event.get("period"),
                        "minute": event.get("minute"),
                        "second": event.get("second"),
                        "timestamp": event.get("timestamp"),
                        "team_id": team.get("id"),
                        "team_name": team.get("name"),
                        "player_id": player.get("id"),
                        "player_name": player.get("name"),
                        "shot_type": (shot.get("type") or {}).get("name", "Unknown"),
                        "shot_outcome": (shot.get("outcome") or {}).get("name", "Unknown"),
                        "shot_xg": shot.get("statsbomb_xg"),
                        "record_source": "statsbomb_open_data",
                        "loaded_at": loaded_at,
                    }
                )

    crosswalk = []
    for player_id, name in sorted(player_names.items(), key=lambda item: int(item[0])):
        crosswalk.append(
            {
                "statsbomb_player_id": player_id,
                "training_registry_id": f"JPN-TR-{player_id}",
                "master_player_id": f"PLAYER-{player_id}",
                "player_name": name,
                "record_source": "training_identity_crosswalk",
                "loaded_at": "2026-11-17T00:00:00",
            }
        )

    write_csv(
        ROOT / "seeds" / "statsbomb_matches.csv",
        sorted(matches, key=lambda row: row["match_date"]),
        [
            "match_id", "season_id", "season_name", "match_date", "kick_off",
            "competition_id", "competition_name", "home_team_id", "home_team_name",
            "home_score", "away_team_id", "away_team_name", "away_score",
            "stage_name", "stadium_name", "record_source", "loaded_at",
        ],
    )
    write_csv(
        ROOT / "seeds" / "statsbomb_lineups.csv",
        sorted(lineups, key=lambda row: (row["match_date"], row["team_name"], row["player_name"])),
        [
            "match_id", "season_name", "match_date", "team_id", "team_name",
            "player_id", "player_name", "jersey_number", "position_name", "is_starter",
            "record_source", "loaded_at",
        ],
    )
    write_csv(
        ROOT / "seeds" / "statsbomb_shots.csv",
        sorted(shots, key=lambda row: (row["match_id"], row["minute"], row["second"])),
        [
            "event_id", "match_id", "period", "minute", "second", "timestamp",
            "team_id", "team_name", "player_id", "player_name", "shot_type",
            "shot_outcome", "shot_xg", "record_source", "loaded_at",
        ],
    )
    write_csv(
        ROOT / "seeds" / "training_player_identity_map.csv",
        crosswalk,
        [
            "statsbomb_player_id", "training_registry_id", "master_player_id",
            "player_name", "record_source", "loaded_at",
        ],
    )
    print(
        f"Wrote {len(matches)} Japan World Cup matches, {len(lineups)} lineup rows, "
        f"{len(shots)} shot events, and {len(crosswalk)} training identity mappings."
    )


if __name__ == "__main__":
    main()
