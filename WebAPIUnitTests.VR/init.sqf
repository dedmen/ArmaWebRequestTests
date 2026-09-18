private _tests = addonFiles ["$mission", ".sqf"] select {_x select [0, 5] == "test_"};

// Clear preflight cache
webRequest #{"type": "flush"};

systemChat format["Running %1 tests...", count _tests];

GStartOffset = time;
_spawns = _tests apply {

  private _code = compile preprocessFileLineNumbers _x;

  _handle = _x spawn 
  {
    try
    {
      private _res = call compile preprocessFileLineNumbers _this;
	    if (isNil "_res") then {_res = "success"};

      if true exitWith { #{"test": _this, "res": _res, "time": time - GStartOffset, "success": true} };
    }
    catch
    {
      systemChat format["%1 threw: %2", _this, _exception];
      if true exitWith { #{"test": _this, "res": _exception, "time": time - GStartOffset, "success": false, "exception": _exception} };
    };
  };
  
  [_x, _handle]

};

//#TODO make sure all finish?


private _results = _spawns apply { private _res = waitUntil (_x select 1); _res };

_successful = _results select {_x get "success"};
_failed = _results select {!(_x get "success")};

systemChat (_failed apply { format["%1: %2", _x get "name", _x get "exception"] } joinString endl);
systemChat format ["Complete, Success %1/%2", count _successful, count _results];

copyToClipboard toJson _results;
systemChat "clip";


