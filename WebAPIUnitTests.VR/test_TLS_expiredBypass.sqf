private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://expired.badssl.com/",
  "verifySSL": false
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// We expect the SSL to work, but preflight still fails because OPTIONS request gets a 405
if ((_result get "body") find "HTTP 405" == -1) throw format["Unexpected HTTP code: %1: %2", _result get "httpCode", _result get "body"];

