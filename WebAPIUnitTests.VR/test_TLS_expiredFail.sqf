private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://expired.badssl.com/"
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

if (_result get "httpCode" != 401) throw format["Unexpected HTTP code: %1", _result get "httpCode"];

// Preflight failed: Certificate validation failed
