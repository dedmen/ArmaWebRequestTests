private _tests = addonFiles ["$mission", ".sqf"] select {_x select [0, 5] == "test_"};

#define WITH_TIME

GStartOffset = time;
_spawns = _tests apply {

  private _code = compile preprocessFileLineNumbers _x;

  _handle = _x spawn 
  {
    try
    {
      private _res = call compile preprocessFileLineNumbers _this;
	    if (isNil "_res") then {_res = "success"};
      #ifdef WITH_TIME
      if (true) exitWith {format["at %1: %2", time - GStartOffset, toJSON _res]};
      #else
      if (true) exitWith {"success"};
      #endif
    }
    catch
    {
      systemChat format["%1 threw: %2", _this, _exception];
      #ifdef WITH_TIME
      if (true) exitWith {format["at %1: %2", time - GStartOffset, _exception]};
      #else
      if (true) exitWith {_exception};
      #endif
    };
  };
  
  [_x, _handle]

};

//#TODO make sure all finish?


private _results = _spawns apply { private _res = waitUntil (_x select 1); [_x select 0, _res] };

private _resString = _results apply { format["%1: %2", _x select 0, _x select 1] } joinString endl;

systemChat _resString;
copyToClipboard _resString;
copyToClipboard _resString;
copyToClipboard _resString;
systemChat "clip";


