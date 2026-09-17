#include "macros.hpp"

private _handle = webRequest #{
  "type": "http",
  "method": "POST",
  "origin": "test",
  "url": "https://localhost:7082/TestCase/CheckHeaders",
  "debug": true,
  "headers": #{
    "Via": "test", // Not allowed
    "CustomHeader": "yes" // Should go through
  },
  "postData": "Hello World" // Exact match check
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(200);

_result