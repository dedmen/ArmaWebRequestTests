#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://myip.wtf/text"
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(200);

_result