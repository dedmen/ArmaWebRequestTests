private _handle = webRequest #{
  "type": "http",
  "url": "https://localhost:7082/CORSTest/ArmaCors" // allows arma://test, but not arma://null
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

if (_result get "httpCode" != 401) throw format["Unexpected HTTP code: %1", _result get "httpCode"];