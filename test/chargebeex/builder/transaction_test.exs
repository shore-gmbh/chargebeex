defmodule Chargebeex.Builder.TransactionTest do
  use ExUnit.Case, async: true

  alias Chargebeex.Builder
  alias Chargebeex.Fixtures.Transaction, as: TransactionFixture
  alias Chargebeex.Transaction

  describe "build/1" do
    test "should build a transaction" do
      built =
        TransactionFixture.retrieve()
        |> Jason.decode!()
        |> Builder.build()

      assert %{"transaction" => %Transaction{}} = built
    end

    test "should have transaction params" do
      built_transaction =
        TransactionFixture.retrieve()
        |> Jason.decode!()
        |> Builder.build()
        |> Map.get("transaction")

      raw_params = TransactionFixture.transaction_params() |> Jason.decode!()
      [linked_invoice] = raw_params["linked_invoices"]

      card =
        built_transaction.payment_method_details
        |> Jason.decode!()
        |> Map.get("card")

      assert built_transaction.id == raw_params["id"]
      assert built_transaction.customer_id == raw_params["customer_id"]
      assert built_transaction.subscription_id == raw_params["subscription_id"]
      assert built_transaction.gateway_account_id == raw_params["gateway_account_id"]
      assert built_transaction.payment_source_id == raw_params["payment_source_id"]
      assert built_transaction.payment_method == raw_params["payment_method"]
      assert built_transaction.gateway == raw_params["gateway"]
      assert built_transaction.type == raw_params["type"]
      assert built_transaction.date == raw_params["date"]
      assert built_transaction.exchange_rate == raw_params["exchange_rate"]
      assert built_transaction.amount == raw_params["amount"]
      assert built_transaction.id_at_gateway == raw_params["id_at_gateway"]
      assert built_transaction.status == raw_params["status"]
      assert built_transaction.updated_at == raw_params["updated_at"]
      assert built_transaction.fraud_reason == raw_params["fraud_reason"]
      assert built_transaction.resource_version == raw_params["resource_version"]
      assert built_transaction.deleted == raw_params["deleted"]
      assert built_transaction.object == raw_params["object"]
      assert built_transaction.masked_card_number == raw_params["masked_card_number"]
      assert built_transaction.currency_code == raw_params["currency_code"]
      assert built_transaction.base_currency_code == raw_params["base_currency_code"]
      assert built_transaction.amount_unused == raw_params["amount_unused"]
      assert built_transaction.business_entity_id == raw_params["business_entity_id"]
      assert built_transaction.initiator_type == raw_params["initiator_type"]
      assert built_transaction.three_d_secure == raw_params["three_d_secure"]

      # Assertions from card struct
      assert card["iin"] == "******"
      assert card["last4"] == "4242"
      assert card["funding_type"] == "credit"
      assert card["expiry_month"] == 12
      assert card["expiry_year"] == 2029
      assert card["masked_number"] == "************4242"
      assert card["brand"] == "visa"
      assert card["object"] == "card"

      # Optional: check linked invoice
      assert [%{"invoice_id" => id}] = built_transaction.linked_invoices
      assert id == linked_invoice["invoice_id"]
    end
  end
end
