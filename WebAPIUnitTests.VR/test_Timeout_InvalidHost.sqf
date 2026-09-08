#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "https://10.0.255.255" // GET is not allowed
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("timed out after");

_result