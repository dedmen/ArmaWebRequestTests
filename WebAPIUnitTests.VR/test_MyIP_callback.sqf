#include "macros.hpp"

_resultArr = [];

private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": "https://myip.wtf/text",
  "onCompleted": { _thisArgs append _this; },
  "callbackContext": _resultArr
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(200);

private _waitRes = waitUntil [{_resultArr isNotEqualTo []}, 5]; // We already waited above, callback fires immediately after, so should be ready.
if (isNil "_waitRes") throw "Wait for callback timed out";

if (_resultArr select 1 isNotEqualTo _result) throw "callback result doesn't match waitUntil result";

_result