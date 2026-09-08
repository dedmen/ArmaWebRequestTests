#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "https://localhost:7082/TestCase/40SecDelay" // GET is not allowed
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

// Operation timed out after 30001 milliseconds with 0 bytes received
EXPECT_FAIL;
EXPECT_ERROR_CONTAINS("Operation timed out after");

_result