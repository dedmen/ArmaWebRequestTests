#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://expired.badssl.com/",
  "verifySSL": false
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// We expect the SSL to work, but preflight still fails because OPTIONS request gets a 405
// Preflight failed: Reason: CORS request got result HTTP 405
EXPECT_FAIL; 
EXPECT_ERROR_CONTAINS("Preflight failed");
EXPECT_ERROR_CONTAINS("Reason: CORS request got result HTTP 405");

_result