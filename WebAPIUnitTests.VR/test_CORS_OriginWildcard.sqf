#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://localhost:7082/CORSTest/Wildcard"
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(200);

_result