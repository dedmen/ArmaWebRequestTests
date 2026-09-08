#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "https://doesnotexist.cim" // GET is not allowed
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("Preflight failed");
EXPECT_ERROR_CONTAINS("Could not resolve host");

_result