#!/usr/bin/env python3

import json
import requests
import sys
import re
import os
import uuid
from datetime import datetime

CONFIG_FILE = "config.json"

def load_config():
    xdg_config_home = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
    config_dir = os.path.join(xdg_config_home, "logme")
    config_path = os.path.join(config_dir, "config.json")

    if not os.path.exists(config_path):
        raise FileNotFoundError(f"Configuration file not found: {config_path}")

    with open(config_path, "r", encoding="utf-8") as fh:
        return json.load(fh)

def get_page_content(confluence_url, page_id, api_token):
    url = f"{confluence_url}/rest/api/content/{page_id}?expand=body.storage,version"
    auth_header = f"Bearer: {api_token}"
    headers = {
        "Accept": "application/json",
        "Authorization": auth_header
    }
    resp = requests.get(url, headers=headers)
    resp.raise_for_status()
    return resp.json()

def update_page_content(confluence_url, page_id, content, api_token):
    url = f"{confluence_url}/rest/api/content/{page_id}"
    auth_header = f"Bearer: {api_token}"
    headers = {
        "Content-Type": "application/json",
        "Authorization": auth_header
    }
    resp = requests.put(url, json=content, headers=headers)
    resp.raise_for_status()
    return resp.json()

def make_task_xml(task_text, task_id=None):
    if task_id is None:
        task_id = str(uuid.uuid4())

    timestamp = datetime.now().strftime("%H:%M")
    body_text = f"[{timestamp}] {task_text}"
    return (
        f"<ac:task>"
        f"<ac:task-id>{task_id}</ac:task-id>"
        f"<ac:task-status>incomplete</ac:task-status>"
        f"<ac:task-body><p>{escape_for_xml(body_text)}</p></ac:task-body>"
        f"</ac:task>"
    )

def escape_for_xml(s):
    return (s.replace("&", "&amp;")
             .replace("<", "&lt;")
             .replace(">", "&gt;"))

def log_task(task):
    cfg = load_config()
    confluence_url = cfg["confluence_url"].rstrip("/")
    auth = cfg["api_token"]
    page_id = cfg["page_id"]

    today_date = datetime.now().strftime("%d.%m.%Y")

    page = get_page_content(confluence_url, page_id, auth)
    current_content = page["body"]["storage"]["value"]
    current_version = page["version"]["number"]
    title = page["title"]
    page_type = page["type"]

    date_patt = re.compile(rf"(<p[^>]*>\s*{re.escape(today_date)}\s*</p>)", re.IGNORECASE)
    m = date_patt.search(current_content)

    task_xml = make_task_xml(task)

    if m:
        insert_after = m.end()
        tail = current_content[insert_after:]

        tasklist_search = re.search(
            r"(<ac:task-list\b[^>]*?>(.*?)</ac:task-list>)",
            tail,
            flags=re.DOTALL | re.IGNORECASE
        )

        if tasklist_search:
            existing_tasklist = tasklist_search.group(1)

            new_tasklist = re.sub(
                    r"(</ac:task-list>)\s*$",
                    task_xml + r"\1",
                    existing_tasklist,
                    flags=re.DOTALL
            )
            tail_updated = tail.replace(existing_tasklist, new_tasklist, 1)
            updated_content = current_content[:insert_after] + tail_updated
        else:
            new_block = f"\n<ac:task-list>{task_xml}</ac:task-list>\n"
            updated_content = current_content[:insert_after] + new_block + current_content[insert_after:]
    else:
        block = f"\n<p>{today_date}</p>\n<ac:task-list>{task_xml}</ac:task-list>\n"
        updated_content = current_content + block

    content = {
        "id": page_id,
        "type": page_type,
        "title": title,
        "version": {"number": current_version + 1},
        "body": {
            "storage": {
                "value": updated_content,
                "representation": "storage"
            }
        }
    }

    update_page_content(confluence_url, page_id, content, auth)
    print(f"Logged task: {task}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python logme.py <task text>")
        sys.exit(1)
    task_text = " ".join(sys.argv[1:]).strip()
    if not task_text:
        print("Empty task")
        sys.exit(1)
    log_task(task_text)
