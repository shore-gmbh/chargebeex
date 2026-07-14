defmodule Chargebeex.BusinessEntityTest do
  use ExUnit.Case, async: true

  import Hammox

  alias Chargebeex.Fixtures.Common

  alias Chargebeex.BusinessEntity

  setup :verify_on_exit!

  describe "transfer" do
    test "with bad authentication should fail" do
      unauthorized = Common.unauthorized()

      expect(
        Chargebeex.HTTPClientMock,
        :post,
        fn url, body, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/business_entities/transfers"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          assert body == ""

          {:ok, 401, [], Jason.encode!(unauthorized)}
        end
      )

      assert {:error, 401, [], ^unauthorized} = BusinessEntity.transfer(%{})
    end

    test "with invalid data should fail" do
      bad_request = Common.bad_request()

      expect(
        Chargebeex.HTTPClientMock,
        :post,
        fn url, body, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/business_entities/transfers"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          assert body == "invalid_attr=invalid"

          {:ok, 400, [], Jason.encode!(bad_request)}
        end
      )

      assert {:error, 400, [], ^bad_request} =
               BusinessEntity.transfer(%{invalid_attr: "invalid"})
    end

    test "given transfer params should build the payload matching the curl and post the request" do
      expect(
        Chargebeex.HTTPClientMock,
        :post,
        fn url, body, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/business_entities/transfers"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          assert URI.decode_query(body) ==
                   %{
                     "active_resource_ids[0]" => "11111111-2222-3333-4444-555555555555",
                     "destination_business_entity_ids[0]" => "AzXY00faketity01",
                     "reason_codes[0]" => "Correction"
                   }

          {:ok, 200, [], Jason.encode!(%{business_entity: %{}})}
        end
      )

      assert {:ok, %BusinessEntity{}} =
               BusinessEntity.transfer(%{
                 active_resource_ids: ["11111111-2222-3333-4444-555555555555"],
                 destination_business_entity_ids: ["AzXY00faketity01"],
                 reason_codes: ["Correction"]
               })
    end

    test "handles a list response (real Chargebee shape for transfers endpoint)" do
      transfer_record = %{
        "id" => "BTLtRyVPMxLF0aPb",
        "object" => "business_entity_transfer",
        "active_resource_id" => "11111111-2222-3333-4444-555555555555",
        "resource_type" => "customer",
        "resource_id" => "BTLtRyVPMxLFlaPi",
        "source_business_entity_id" => "BTcXXMTqZddGWfc",
        "destination_business_entity_id" => "AzXY00faketity01",
        "reason_code" => "correction",
        "created_at" => 1_784_049_846
      }

      expect(
        Chargebeex.HTTPClientMock,
        :post,
        fn _url, _body, _headers ->
          {:ok, 200, [],
           Jason.encode!(%{
             "list" => [%{"business_entity_transfer" => transfer_record}],
             "next_offset" => nil
           })}
        end
      )

      assert {:ok, [_ | _], %{"next_offset" => nil}} =
               BusinessEntity.transfer(%{
                 active_resource_ids: ["11111111-2222-3333-4444-555555555555"],
                 destination_business_entity_ids: ["AzXY00faketity01"],
                 reason_codes: ["Correction"]
               })
    end
  end
end
