import Config

config :chargebeex,
  namespace: "test-namespace",
  api_key: "test_chargeebee_api_key",
  http_client: Chargebeex.HTTPClientMock

config :chargebeex, :alternative,
  namespace: "alternative-namespace",
  api_key: "test_chargeebee_api_key",
  http_client: Chargebeex.HTTPClientMock
