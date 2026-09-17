#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://expired.badssl.com/",
  "debug": true
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// Preflight failed: Certificate validation failed
EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("Preflight failed");
EXPECT_ERROR_CONTAINS("Certificate validation failed");

_result