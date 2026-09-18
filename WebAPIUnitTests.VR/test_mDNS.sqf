#include "macros.hpp"

private _handle = webRequest #{
  "type": "mdns"
};

systemChat "wait";

private _result = waitUntil _handle;
_result params ["_request", "_result"];

if (count _result == 0) throw "Unexpected no services found";
if (!("ASPNetSample._arma3web._tcp.local" in _result)) throw "Service not found";

private _service = _result get "ASPNetSample._arma3web._tcp.local";

if (!("version=1.0" in (_service get "TXT"))) throw "Missing TXT entry";

private _srv = selectRandom (_service get "SRV"); //#TODO selectRandomWeighted would be fun, use the weights.

// But actually one is a test with wrong port so..
_srv = ((_service get "SRV") select {_x get "port" == 7082}) select 0;

private _port = _srv get "port";
private _host = _srv get "name";

// Linux supports resolving mDNS service names, Windows doesn't. Just assemble it manually

private _addresses = _service get "ADDR" get _host;

private _address = selectRandom _addresses;

private _urlBase = format["https://%1:%2", _address, _port];

private _handle = webRequest #{
  "type": "http",
  "origin": "test",
  "url": format["%1/CORSTest/ArmaCors", _urlBase],
  "verifySSL": false,
  "debug": true
};

private _result = waitUntil _handle;
_result params ["_request", "_result"];

EXPECT_SUCCESS_CODE(200);

_result