#include "macros.hpp"

private _senderContext = createHashMap;
private _receiverContext = createHashMap;

private _cfg = #{
  "type": "websocket",
  "origin": "test",
  "url": "wss://localhost:7082/websocket/relay",
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
  "callbackContext": _senderContext,
  "verifySSL": false
};

private _senderHandle = webRequest _cfg;
_cfg set ["callbackContext", _receiverContext];
private _receiverHandle = webRequest _cfg;


private _result = waitUntil _senderHandle; // Wait until connected
_result params ["_request", "_result"];
EXPECT_SUCCESS_CODE(101); // Upgrade

private _result = waitUntil _receiverHandle; // Wait until connected
_result params ["_request", "_result"];
EXPECT_SUCCESS_CODE(101); // Upgrade


// Send something
webRequest #{
  "type": "send",
  "connection": _senderHandle,
  "data": "Message to Send"
};

// It should echo back
waitUntil [{"received" in _receiverContext}, 5];
if (!("received" in _receiverContext)) throw "Failed to receive echo";
private _data = _receiverContext get "received";
if (_data != "Message to Send") throw format ["Unexpected echo data: %1", _data];

// Other way around

// Send something
webRequest #{
  "type": "send",
  "connection": _receiverHandle,
  "data": "Message to Send"
};

// It should echo back
waitUntil [{"received" in _senderContext}, 5];
if (!("received" in _senderContext)) throw "Failed to receive echo";
private _data = _senderContext get "received";
if (_data != "Message to Send") throw format ["Unexpected echo data: %1", _data];

// Disconnect (Loose last reference to it)
_senderHandle = nil;
_receiverHandle = nil;

waitUntil [{"lost" in _senderContext}, 5];
private _lossReason = _senderContext get "lost" get "error";
if (_lossReason != "Request Cancelled") throw format ["Unexpected disconnect error: %1", _lossReason];

waitUntil [{"lost" in _receiverContext}, 5];
private _lossReason = _receiverContext get "lost" get "error";
if (_lossReason != "Request Cancelled") throw format ["Unexpected disconnect error: %1", _lossReason];

_result