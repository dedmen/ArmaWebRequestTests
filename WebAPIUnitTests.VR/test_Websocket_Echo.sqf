#include "macros.hpp"

private _context = createHashMap;

private _handle = webRequest #{
  "type": "websocket",
  "origin": "test",
  "url": "wss://localhost:7082/websocket/echo",
  "debug": true,

  "onWebsocketEstablished": {
    _thisArgs set ["connected", _this select 1];
  },
  "onWebsocketLost": {
    _thisArgs set ["lost", _this select 1];
  },
  "onWebsocketDataReceived": {
    _thisArgs set ["received", _this select 1];
  },
  "callbackContext": _context,
  "verifySSL": false
};

private _result = waitUntil _handle; // Wait until connected
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(101); // Upgrade

// Send something

webRequest #{
  "type": "send",
  "connection": _handle,
  "data": "Message to Send"
};

// It should echo back

waitUntil [{"received" in _context}, 5];

if (!("received" in _context)) throw "Failed to receive echo";

private _data = _context get "received";

if (_data != "Message to Send") throw format ["Unexpected echo data: %1", _data];

// Disconnect (Loose last reference to it)
_handle = nil;

waitUntil [{"lost" in _context}, 5];

private _lossReason = _context get "lost" get "error";

if (_lossReason != "Request Cancelled") throw format ["Unexpected disconnect error: %1", _lossReason];

_result