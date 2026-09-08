#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "url": "https://localhost:7082/TestCase/5SecDelay" // GET is not allowed
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(200);

_result