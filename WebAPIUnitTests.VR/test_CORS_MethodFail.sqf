#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "https://localhost:7082/CORSTest/ArmaPUT" // GET is not allowed
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// Preflight failed: Did not find method in CORS header 'Access-Control-Allow-Methods'
EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("Preflight failed");
EXPECT_ERROR_CONTAINS("Did not find method in CORS header 'Access-Control-Allow-Methods'");

_result