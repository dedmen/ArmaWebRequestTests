#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "http://10.0.0.3/" // OPTIONS returns 405
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// Preflight failed: CORS header 'Access-Control-Allow-Origin' missing
EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("Preflight failed");
EXPECT_ERROR_CONTAINS("CORS header 'Access-Control-Allow-Origin' missing");

_result