#!/usr/bin/python

import requests
import json
import sys
import time
import datetime

post_url = 'http://172.30.1.21:6680/mopidy/rpc';
headers = {'Content-type': 'application/json'}

def stop():
    data = {}
    data["method"] = "core.playback.stop";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    json_data = json.dumps(data)
    x = requests.post(post_url, data = json_data, headers=headers)


def get_tracks():
    data = {}
    data["method"] = "core.tracklist.get_tl_tracks";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    json_data = json.dumps(data)
    x = requests.post(post_url, data = json_data, headers=headers)

def get_tracks():
    data = {}
    data["method"] = "core.tracklist.get_tl_tracks";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    json_data = json.dumps(data)
    print("Test = " + json_data)
    response = requests.post(post_url, data = json_data, headers=headers)
    uris = [];
    print(response.text)
    for track in response.json()["result"]["tracks"]:
        uris.append(track["uri"]);
    return uris

def lookup_library(uris):
    data = {}
    data["method"] = "core.library.lookup";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    data["params"] = {'uris':uris};
    json_data = json.dumps(data)
    x = requests.post(post_url, data = json_data, headers=headers)

def add_tracks(uris):
    data = {}
    data["method"] = "core.tracklist.add";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    data["params"] = {'uris':uris};
    json_data = json.dumps(data)
    x = requests.post(post_url, data = json_data, headers=headers)
    first_track = ""
    for idx,track in enumerate(uris):
        #print("Appending " + track)
        if idx==0:
            first_track = track
            print("First track " + first_track)
    return first_track

def lookup_playlist(uri):
    data = {}
    data["method"] = "core.playlists.lookup";
    data["jsonrpc"] = "2.0";
    fulluri = {}
    fulluri['uri'] = "m3u:" + uri;
    data["params"] = fulluri;
    data["id"] = 1;
    json_data = json.dumps(data)
    response = requests.post(post_url, data = json_data, headers=headers)
    uris = [];
    print(response.text)
    for track in response.json()["result"]["tracks"]:
        uris.append(track["uri"]);
    return uris

def clear_playlist_queue():
    data = {}
    data["method"] = "core.tracklist.clear";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    json_data = json.dumps(data)
    x = requests.post(post_url, data = json_data, headers=headers)

def play_first_item_in_queue(tlid):
    data = {}
    data["method"] = "core.playback.play";
    data["jsonrpc"] = "2.0";
    data["id"] = 1;
    tlobj = {}
    tlobj["tlid"] = tlid
    data["params"] = tlobj;
    print(json.dumps(data))
    json_data = json.dumps(data)
    x = requests.post(post_url, data = json_data, headers=headers)
    print(x.text)

def get_tlid(uri):
    data = {}
    data["method"] = "core.tracklist.filter";
    data["jsonrpc"] = "2.0";
    data["id"] = 2;
    uriobj = {}
    uriobj["uri"] = [uri]
    criobj = {}
    criobj["criteria"] = uriobj
    data["params"] = criobj
    json_data = json.dumps(data)
    response = requests.post(post_url, data = json_data, headers=headers)
    print(response.json()['result'][0]['tlid'])
    return response.json()['result'][0]['tlid']


if __name__ == "__main__":
    #print(sys.argv[1]);
    clear_playlist_queue();
    print(len(sys.argv))
    dow = datetime.datetime.today().weekday() + 1
    playlist = str(dow) + ".m3u"
    if(len(sys.argv)!=1):
        playlist = sys.argv[1]
    print("Playlist " + playlist)
    uris = lookup_playlist(playlist)
    #print(first_track)
    #uris = get_tracks()
    first_track = add_tracks(uris)
    tlid = get_tlid(first_track)
    play_first_item_in_queue(tlid);