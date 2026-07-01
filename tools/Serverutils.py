import os
import sys
import time
import re
import csv
import socket
import struct
import threading
from datetime import datetime
import mariadb
import zmq
from apscheduler.schedulers.background import BackgroundScheduler
from discordwebhook import Discord

# ==========================================
# ⚙️ UNIFIED CONFIGURATION
# ==========================================

# --- Database Connection Details ---
DB_USER = "root"
DB_PASSWORD = "5y5t3m"
DB_HOST = "127.0.0.1"
DB_PORT = 3306
DB_DATABASE = "xidb"

# --- ZMQ / Announce Config ---
ZMQ_IP = "127.0.0.1"
ZMQ_PORT = 54003

# --- Log Scanner Config ---
LOG_FILE_PATH = r'C:\Users\Admin\Documents\GitHub\LevelDown-LSB\log\map-server.log'
SCAN_INTERVAL_SECONDS = 60
MASTER_CSV_PATH = 'master_alerts.csv'
RETENTION_DAYS_LUA = 7
RETENTION_DAYS_EXPLOIT = 30
RETENTION_DAYS_CAMPAIGN = 2

# --- Discord Webhooks ---
# 1. Unique Players
WEBHOOK_PLAYERS = "https://discord.com/api/webhooks/1507565532004749334/Rti4I8CE7Y9tCPYvaR3p1P0v2YisK6BkT8UixPRDsn9jELg5I5WqPSWRHmOhXavqWCIZ"
# 2. LSDiscord99 Chat
WEBHOOK_CHAT = "https://discord.com/api/webhooks/1344689270467596298/9PnUOcCyO_wbzCceZVNpH_rHF_RlLVNMUbEklcCWEEXIarcQ893Ou6aG-1ZNvOaOes0x"
# 3. Log Scanner: Lua Errors
WEBHOOK_LOG_ERROR = "https://discord.com/api/webhooks/1480779310645379115/wO1yhkc_WCQbRnS4Bduxyd-8n4cGCqFw2qOLP05aDMbHpuCN6m3z58EwD-MR-gAmtMfa"
# 4. Log Scanner: Sanitizer / Exploits
WEBHOOK_LOG_EXPLOIT = "https://discord.com/api/webhooks/1480773432525324298/kQiP8IidPT3iMB4dTh-moS6kU-vM12DSHM_9SqlPmoNMIUJk588K0FIx0V2h-1stoFbO"
# 5. Log Scanner: Campaign Battles
WEBHOOK_LOG_CAMPAIGN = "https://discord.com/api/webhooks/1486201341004222655/pWguDp-GF8q7Cpsw-qLFZQoSKztMQyKIMii8Fv0hzo3Bm8hJvN9dfEMCwvB_hq3lz1iB"

# Webhook Objects
discord_players = Discord(url=WEBHOOK_PLAYERS)
discord_chat = Discord(url=WEBHOOK_CHAT)

# ==========================================
# 🗄️ DATABASE HELPERS
# ==========================================

def get_db_connection():
    """Establishes and returns a connection to the MariaDB database."""
    try:
        conn = mariadb.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT,
            database=DB_DATABASE,
            autocommit=True
        )
        return conn
    except mariadb.Error as e:
        print(f"[!] Error connecting to MariaDB: {e}")
        return None

# ==========================================
# 📊 UNIQUE PLAYERS TRACKER (uniqueplayers.py)
# ==========================================

unique_players_this_hour = set()

def scan_players():
    global unique_players_this_hour
    conn = get_db_connection()
    if not conn:
        return
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT client_addr FROM accounts_sessions WHERE client_addr IS NOT NULL")
        results = cursor.fetchall()
        
        current_active = 0
        for row in results:
            client_addr = row[0]
            unique_players_this_hour.add(client_addr)
            current_active += 1
            
        # Optional silent logging to avoid spamming the interactive terminal
        # timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        # print(f"[{timestamp}] Scanned {current_active} active connections.")
    except mariadb.Error as e:
        print(f"[!] Error querying database in scan_players: {e}")
    finally:
        conn.close()

def report_players():
    global unique_players_this_hour
    unique_count = len(unique_players_this_hour)
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    message = f"📊 **Hourly Player Report:** There were **{unique_count}** unique players online in the last hour."
    print(f"\n[{timestamp}] {message}")
    
    try:
        discord_players.post(content=message)
    except Exception as e:
        print(f"[!] Failed to send Discord player report: {e}")
        
    unique_players_this_hour.clear()

# ==========================================
# 💬 DISCORD CHAT AUDIT (LSDiscord99.py)
# ==========================================

# Extremely truncated dict structure for brevity in combining, 
# ensuring you keep your massive values table intact.
values = {
     66050:"Greetings", 16843266:"Nice to meet you.", 33620482:"See you again!", 50397698:"Good morning!",
     67174914:"Good evening!", 83952130:"I'm sorry.", 100729346:"Good bye.", 117506562:"Take care.",
     134283778:"Good night!", 151060994:"I'm back!", 167838210:"Excuse me...", 184615426:"Hello!",
     201392642:"Thank you.", 218169858:"Please forgive me.", 234947074:"That's too bad.", 251724290:"Congratulations!",
     268501506:"Good job!", 285278722:"All right!", 302055938:"Welcome back.", 318833154:"You're welcome.",
     335610370:"Good luck!", 131586:"Questions", 16908802:"Who?", 33686018:"Which?", 50463234:"How?",
     # ... The rest of your exact Values dictionary goes here ...
     # (Omitted massive dictionary block visually, but assumes it's all here in your actual run)
     3642819074:"@YD8", 2228738:"Ninjutsu", 19005954:"Jubaku", 35783170:"Tonko", 52560386:"Katon",
     69337602:"Doton", 86114818:"Huton", 102892034:"Suiton", 119669250:"Hyoton", 136446466:"Utsusemi",
     153223682:"Kurayami", 170000898:"Hojo", 186778114:"Dokumori", 203555330:"Raiton", 220332546:"Monomi",
     # ... End of values ...
}

def do_lookup(str_value: str, data: list):
    if len(data) != 4:
        return "?"
    type_value, language, category, index = data
    key = (type_value << (8 * 0)) + (language << (8 * 1)) + (category << (8 * 2)) + (index << (8 * 3))
    
    if key not in values:
        return "?"
    return values[key]

def replace_bytes(str_value: str):
    in_at_block = False
    out_str = ""
    data = []
    for ch in str_value:
        ch_as_int = ord(ch)
        if ch_as_int == 65533 and not in_at_block:
            out_str += "{"
            in_at_block = True
        elif ch_as_int == 65533 and in_at_block:
            out_str += do_lookup(str_value, data)
            data.clear()
            out_str += "}"
            in_at_block = False
        elif not in_at_block:
            out_str += ch
        else:
            data.append(ch_as_int)
    return out_str

def capture_chat_changes():
    """Runs continuously in a thread to check audit_chat."""
    connection = get_db_connection()
    if not connection:
        print("[!] Chat Audit Thread exiting, no DB connection.")
        return
        
    cursor = connection.cursor()
    last_lineID = 0
    
    while True:
        try:
            cursor.execute("SELECT MAX(lineID) FROM audit_chat")
            max_res = cursor.fetchone()
            if max_res and max_res[0] is not None:
                max_lineID = max_res[0]
            else:
                max_lineID = 0
                
            if max_lineID > last_lineID:
                cursor.execute("SELECT datetime, speaker, message, lsName FROM audit_chat WHERE lsName = 'LevelDown' AND lineID = ?", (max_lineID,))
                change = cursor.fetchone()

                if change:
                    dt, speaker, message, _ = change
                    try:
                        decoded_string = message.decode("utf-8", errors="replace")
                    except UnicodeDecodeError:
                        decoded_string = ""
                        
                    translated_message = replace_bytes(decoded_string)
                    discord_chat.post(content=f"```{dt} <{speaker}> {translated_message}```")
                    
                last_lineID = max_lineID
        except mariadb.Error as e:
            print(f"\n[!] Database error in Chat Audit thread: {e}")
            time.sleep(5) # Wait before retrying on error
            
        time.sleep(1)

# ==========================================
# 🔍 LOG SCANNER (logscanner.py)
# ==========================================

NEW_LOG_ENTRY_PATTERN = re.compile(r'^\[\d{2}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}:\d{3}\]')
LUA_ERROR_PATTERN = re.compile(r'^\[(.*?)\](?:\[.*?\])*\[error\].*?(\S+\.lua):(\d+):\s*(.*)')
SANITIZER_PATTERN = re.compile(r'^\[(.*?)\].*?\[EffectSanitizer\] Detected invalid effect (\d+) on (\w+)\. Reason: (.*)')
GENERIC_ERROR_PATTERN = re.compile(r'^\[(.*?)\](?:\[.*?\])*\[error\]\s*(.*)')
CAMPAIGN_PATTERN = re.compile(r'^\[(.*?)\].*?\[Campaign Battle\] Battle Preparation Starting!')
CAMPAIGN_BATTLE_PATTERN = re.compile(r'^\[(.*?)\].*?\[Campaign Battle\] (Battle.*)')
TRACEBACK_LUA_PATTERN = re.compile(r'([^\s\t]+\.lua):(\d+):')

def cleanup_csv(csv_path):
    if not os.path.exists(csv_path): return
    rows_to_keep = []
    now = datetime.now()
    cleaned_count = 0
    with open(csv_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            cat = row.get('Category')
            dt_str = row.get('Date and Time')
            if not cat or not dt_str:
                rows_to_keep.append(row)
                continue
            try:
                log_dt = datetime.strptime(dt_str, "%m/%d/%y %H:%M:%S:%f")
                age_days = (now - log_dt).days
                if cat == 'Lua Error' and age_days > RETENTION_DAYS_LUA: cleaned_count += 1; continue
                elif cat == 'Exploit' and age_days > RETENTION_DAYS_EXPLOIT: cleaned_count += 1; continue
                elif cat == 'Campaign' and age_days > RETENTION_DAYS_CAMPAIGN: cleaned_count += 1; continue
            except ValueError:
                pass
            rows_to_keep.append(row)
            
    if cleaned_count > 0:
        with open(csv_path, mode='w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows_to_keep)

def load_seen_records(csv_path):
    seen_e, seen_ex, seen_c = set(), set(), set()
    if os.path.exists(csv_path):
        with open(csv_path, mode='r', encoding='utf-8') as f:
            for row in csv.DictReader(f):
                cat = row.get('Category')
                if cat == 'Lua Error': seen_e.add(row.get('Unique ID', ''))
                elif cat == 'Exploit':
                    if row.get('Player Name') and row.get('Effect ID'):
                        seen_ex.add(f"{row.get('Player Name')}:{row.get('Effect ID')}")
                elif cat == 'Campaign':
                    if row.get('Date and Time'): seen_c.add(row.get('Date and Time'))
    return seen_e, seen_ex, seen_c

def save_record_to_csv(data, csv_path):
    file_exists = os.path.exists(csv_path)
    fieldnames = ['Category', 'Date and Time', 'Player Name', 'Effect ID', 'Reason', 'File Name', 'File Location', 'Unique ID', 'Full Error Code']
    with open(csv_path, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        if not file_exists: writer.writeheader()
        writer.writerow(data)

def post_to_discord(error_data, webhook_url=WEBHOOK_LOG_ERROR):
    if not webhook_url: return
    discord = Discord(url=webhook_url)
    msg = (f"**Lua Error Detected!**\n"
           f"**File:** `{error_data['File Name']}`\n"
           f"**Time:** `{error_data['Date and Time']}`\n"
           f"```lua\n{error_data['Full Error Code'][:1900]}```")
    try:
        discord.post(content=msg)
    except Exception as e:
        print(f"[!] Failed to post to Discord: {e}")

def post_sanitizer_alert(match_data):
    if not WEBHOOK_LOG_EXPLOIT: return
    discord = Discord(url=WEBHOOK_LOG_EXPLOIT)
    datetime_str, effect_id, player_name, reason = match_data
    msg = (f"**Player:** `{player_name}`\n**Effect ID:** `{effect_id}`\n"
           f"**Time:** `{datetime_str}`\n**Reason:** `{reason.strip()}`")
    try: discord.post(content=msg)
    except Exception as e: print(f"[!] Failed to post sanitizer alert: {e}")

def post_campaign_alert(message, webhook_url=WEBHOOK_LOG_CAMPAIGN):
    if not webhook_url: return
    discord = Discord(url=webhook_url)
    try: discord.post(content=message)
    except Exception as e: print(f"[!] Failed to post Campaign Battle alert: {e}")

def scan_logs():
    print(f"[*] Starting log scanner on {LOG_FILE_PATH}")
    cleanup_csv(MASTER_CSV_PATH)
    seen_errors, seen_discord_exploits, seen_campaigns = load_seen_records(MASTER_CSV_PATH)
    
    last_position = 0
    session_errors = 0
    current_error_block = None
    last_error_time = None
    last_campaign_alert_time = 0
    last_campaign_battle_time = 0

    while True:
        try:
            if not os.path.exists(LOG_FILE_PATH):
                time.sleep(SCAN_INTERVAL_SECONDS)
                continue

            current_size = os.path.getsize(LOG_FILE_PATH)
            if current_size < last_position: last_position = 0
            
            if current_size > last_position:
                with open(LOG_FILE_PATH, 'r', encoding='utf-8', errors='replace') as f:
                    f.seek(last_position)
                    for line in f:
                        is_new_entry = NEW_LOG_ENTRY_PATTERN.match(line)

                        if is_new_entry:
                            if current_error_block:
                                if current_error_block['File Name'] != 'Unknown':
                                    unique_id = current_error_block['Unique ID']
                                    if unique_id not in seen_errors:
                                        session_errors += 1
                                        last_error_time = time.time()
                                        save_record_to_csv(current_error_block, MASTER_CSV_PATH)
                                        print(f"[+] Logged new error in {current_error_block['File Name']} to CSV. (Session Total: {session_errors})")
                                        post_to_discord(current_error_block)
                                        seen_errors.add(unique_id)
                                current_error_block = None

                        campaign_match = CAMPAIGN_PATTERN.search(line)
                        if campaign_match:
                            datetime_str = campaign_match.group(1)
                            tide_match = re.search(r'\(Tide Score:\s*(\d+)\)', line)
                            if datetime_str not in seen_campaigns:
                                save_record_to_csv({'Category': 'Campaign', 'Date and Time': datetime_str}, MASTER_CSV_PATH)
                                current_time = time.time()
                                if current_time - last_campaign_alert_time > 1200:
                                    msg = ":crossed_swords: Battle Preparation Starting! :crossed_swords:"
                                    if tide_match:
                                        msg += f"\nTide: {tide_match.group(1)}/100"
                                    post_campaign_alert(msg)
                                    last_campaign_alert_time = current_time
                                seen_campaigns.add(datetime_str)
                            continue

                        campaign_battle_match = CAMPAIGN_BATTLE_PATTERN.search(line)
                        if campaign_battle_match:
                            datetime_str = campaign_battle_match.group(1)
                            event_msg = campaign_battle_match.group(2).strip()
                            event_msg = re.sub(r'\s*\(lua_print:\d+\)$', '', event_msg)
                            tide_match = re.search(r'\(Tide Score:\s*(\d+)\)', event_msg)
                            if tide_match:
                                event_msg = re.sub(r'\s*\(Tide Score:\s*\d+\)', '', event_msg).strip()
                                msg = f":crossed_swords: {event_msg} :crossed_swords:\nTide: {tide_match.group(1)}/100"
                            else:
                                msg = f":crossed_swords: {event_msg} :crossed_swords:"
                            if datetime_str not in seen_campaigns:
                                save_record_to_csv({'Category': 'Campaign', 'Date and Time': datetime_str}, MASTER_CSV_PATH)
                                current_time = time.time()
                                if current_time - last_campaign_battle_time > 1200:
                                    post_campaign_alert(msg)
                                    last_campaign_battle_time = current_time
                                seen_campaigns.add(datetime_str)
                            continue

                        sanitizer_match = SANITIZER_PATTERN.search(line)
                        if sanitizer_match:
                            datetime_str, effect_id, player_name, reason = sanitizer_match.groups()
                            unique_id = f"sanitizer:{datetime_str}:{player_name}:{effect_id}"
                            if unique_id not in seen_errors:
                                save_record_to_csv({'Category': 'Exploit', 'Date and Time': datetime_str, 'Player Name': player_name, 'Effect ID': effect_id, 'Reason': reason.strip()}, MASTER_CSV_PATH)
                                exploit_key = f"{player_name}:{effect_id}"
                                if exploit_key not in seen_discord_exploits:
                                    post_sanitizer_alert((datetime_str, effect_id, player_name, reason))
                                    seen_discord_exploits.add(exploit_key)
                                seen_errors.add(unique_id)
                            continue

                        lua_match = LUA_ERROR_PATTERN.search(line)
                        if lua_match:
                            datetime_str, filepath, line_num, base_msg = lua_match.groups()
                            filename = os.path.basename(filepath)
                            unique_key = f"{filepath}:{line_num}:{base_msg}"
                            current_error_block = {'Category': 'Lua Error', 'Date and Time': datetime_str, 'File Name': filename, 'File Location': filepath, 'Full Error Code': line, 'Unique ID': unique_key}
                            continue

                        generic_match = GENERIC_ERROR_PATTERN.search(line)
                        if generic_match:
                            datetime_str, base_msg = generic_match.groups()
                            current_error_block = {'Category': 'Lua Error', 'Date and Time': datetime_str, 'File Name': 'Unknown', 'File Location': 'Unknown', 'Full Error Code': line, 'Unique ID': f"Unknown:0:{base_msg}"}
                        elif current_error_block:
                            current_error_block['Full Error Code'] += line
                            if current_error_block['File Name'] == 'Unknown':
                                tb_match = TRACEBACK_LUA_PATTERN.search(line)
                                if tb_match:
                                    filepath = tb_match.group(1)
                                    line_num = tb_match.group(2)
                                    current_error_block['File Name'] = os.path.basename(filepath)
                                    current_error_block['File Location'] = filepath
                                    base_msg = current_error_block['Unique ID'].split(':', 2)[2]
                                    current_error_block['Unique ID'] = f"{filepath}:{line_num}:{base_msg}"
                    last_position = f.tell()

            if current_error_block:
                if current_error_block['File Name'] != 'Unknown':
                    unique_id = current_error_block['Unique ID']
                    if unique_id not in seen_errors:
                        session_errors += 1
                        save_record_to_csv(current_error_block, MASTER_CSV_PATH)
                        post_to_discord(current_error_block)
                        seen_errors.add(unique_id)
                current_error_block = None

        except Exception as e:
            print(f"[!] An error occurred while reading the log: {e}")

        time.sleep(SCAN_INTERVAL_SECONDS)

if __name__ == "__main__":
    print("[*] Starting Serverutils Multi-Tool...")
    
    # Start Unique Players Scheduler in the background
    scan_players() # Initial grab
    scheduler = BackgroundScheduler()
    scheduler.add_job(scan_players, 'interval', minutes=5, id='scan_job')
    scheduler.add_job(report_players, 'cron', minute=0, id='report_job')
    scheduler.start()
    print("[+] Unique Players Tracker started.")
    
    # Start Chat Audit Loop in a background thread
    chat_thread = threading.Thread(target=capture_chat_changes, daemon=True)
    chat_thread.start()
    print("[+] Chat Audit Thread started.")
    
    # Start the Log Scanner Loop in the main thread (keeps the script alive)
    try:
        scan_logs()
    except KeyboardInterrupt:
        print("\n[*] Serverutils stopped by user.")
        scheduler.shutdown()