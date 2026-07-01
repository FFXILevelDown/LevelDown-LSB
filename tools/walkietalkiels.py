import discord
import os
import zmq 
import socket
import struct

# ==========================================
#               CONFIGURATION
# ==========================================
# This is a Bot Token, NOT a Webhook URL!
DISCORD_BOT_TOKEN = "MTQ4MDkzMzE5ODY0NDExNzY4OA.Gaf10r.cG5wCsFWoc4LKeBHAwc2MkrMlB6Hi38lI62GyA"

# The exact name of the channel the bot should listen to
LISTEN_CHANNEL_NAME = "99-ls-chat" 
# Target Linkshell ID (1 is usually the first LS created)
TARGET_LS_ID = 1
ZMQ_IP = "127.0.0.1"
ZMQ_PORT = 54003
# ==========================================

context = zmq.Context()
sock = context.socket(zmq.DEALER)

ip_bytes = socket.inet_aton(ZMQ_IP)
(ip_int,) = struct.unpack("!I", ip_bytes)
ipp = ip_int | (ZMQ_PORT << 32)
ipp_bytes = struct.pack("!Q", ipp)

sock.setsockopt(zmq.ROUTING_ID, ipp_bytes)
sock.connect(f"tcp://{ZMQ_IP}:{ZMQ_PORT}")

def encode_varint(value):
    bytes_list = bytearray()
    while value > 127:
        bytes_list.append((value & 127) | 128)
        value >>= 7
    bytes_list.append(value & 127)
    return bytes_list

def build_ls_packet(sender, msg, ls_id):
    buffer = bytearray()
    buffer.append(8) # ChatMessageLinkshell type
    buffer.extend(encode_varint(ls_id))
    buffer.extend(encode_varint(0))
    buffer.extend(encode_varint(len(sender)))
    buffer.extend(sender.encode("utf-8"))
    buffer.extend(encode_varint(len(msg)))
    buffer.extend(msg.encode("utf-8"))
    buffer.extend(struct.pack("<H", 0))
    buffer.append(0)
    return buffer

intents = discord.Intents.default()
intents.message_content = True
client = discord.Client(intents=intents)

@client.event
async def on_ready():
    print(f"[*] Relay Active.")
    print(f"[*] Ignoring all messages starting with [Linkshell Log]")

@client.event
async def on_message(message):
    # 1. Ignore if it's a Bot or Webhook (The most reliable fix)
    if message.author.bot or message.webhook_id is not None:
        return

    # 2. Ignore styled/formatted names (e.g., **Name:**)
    # This checks if the message starts with ** and contains :**
    # This covers the styling regardless of the specific character name.
    clean_text = message.content.strip()
    if clean_text.startswith("**") and ":**" in clean_text[:30]:
        print(f"[Ignored] Styled log message: {clean_text}")
        return

    # 3. Ignore the specific [Linkshell Log] text just in case
    if "[Linkshell Log]" in clean_text:
        return

    # 4. Only process human messages in the correct channel
    if message.channel.name == LISTEN_CHANNEL_NAME:
        display_sender = f"[{message.author.display_name}]"
        
        try:
            packet = build_ls_packet(display_sender, message.content, TARGET_LS_ID)
            sock.send(packet)
            print(f"[Success] Relayed human message: {message.content}")
        except Exception as e:
            print(f"[ZMQ Error]: {e}")

if __name__ == "__main__":
    client.run(DISCORD_BOT_TOKEN)