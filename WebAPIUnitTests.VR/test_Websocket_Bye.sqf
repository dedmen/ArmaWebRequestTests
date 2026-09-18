#include "macros.hpp"

private _context = createHashMap;

private _handle = webRequest #{
  "type": "websocket",
  "origin": "test",
  "url": "wss://localhost:7082/websocket/bye",
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

// Within 500ms, server should send Bye with reason

waitUntil [{"lost" in _context}, 2];

if (!("lost" in _context)) throw "Failed to receive disconnect";

private _lossReason = _context get "lost" get "error";

if (_lossReason != "PolicyViolation: Close description") throw format ["Unexpected disconnect error: %1", _lossReason];

_result