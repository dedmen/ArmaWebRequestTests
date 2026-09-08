private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://localhost:7082/CORSTest/Wildcard"
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

if (_result get "httpCode" != 200) throw format["Unexpected HTTP code: %1", _result get "httpCode"];
