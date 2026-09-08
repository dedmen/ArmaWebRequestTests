private _handle = webRequest #{
  "type": "http",
  "url": "https://localhost:7082/CORSTest/NoCORS" // OPTIONS returns 405
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

if (_result get "httpCode" != 401) throw format["Unexpected HTTP code: %1", _result get "httpCode"];

if ((_result get "body") find "Preflight failed" == -1) throw format["Unexpected HTTP code: %1: %2", _result get "httpCode", _result get "body"];

if ((_result get "body") find "CORS header 'Access-Control-Allow-Origin' missing" == -1) throw format["Unexpected HTTP code: %1: %2", _result get "httpCode", _result get "body"];