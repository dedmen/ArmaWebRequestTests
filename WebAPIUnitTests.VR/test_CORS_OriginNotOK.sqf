#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "https://localhost:7082/CORSTest/ArmaCors" // allows arma://test, but not arma://null
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// Preflight failed: Reason: CORS header 'Access-Control-Allow-Origin' missing
EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("Preflight failed");
EXPECT_ERROR_CONTAINS("CORS header 'Access-Control-Allow-Origin' missing"); // This is annoying, it should provide one, but not with our origin

_result