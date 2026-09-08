private _tests = addonFiles ["$mission", ".sqf"] select {_x select [0, 5] == "test_"};


_spawns = _tests apply {

  private _code = compile preprocessFileLineNumbers _x;

  _handle = _x spawn 
  {
    try
    {
      private _res = call compile preprocessFileLineNumbers _this;
	  if (isNil "_res") then {_res = "success"};
	  _res
    }
    catch
    {
      systemChat format["%1 threw: %2", _this, _exception];
	  "error";
    };
  };
  
  [_x, _handle]

};

//#TODO make sure all finish?


private _results = _spawns apply { private _res = waitUntil (_x select 1); [_x select 0, _res] };

systemChat str _results;


