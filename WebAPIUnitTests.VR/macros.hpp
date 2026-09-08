#define EXPECT_FAIL if (!("error" in _result)) throw format["Expected error, but got success: %1", _result get "httpCode"]
#define EXPECT_ERROR_CONTAINS(x) if (!(x in (_result get "error"))) throw format["Unexpected error content: %1", _result get "error"]
#define EXPECT_SUCCESS if ("error" in _result) throw format["Unexpected error: %1", _result get "error"];
#define EXPECT_SUCCESS_CODE(x) EXPECT_SUCCESS; if ((_result get "httpCode") != x) throw format["Unexpected result code: %1", _result get "httpCode"];