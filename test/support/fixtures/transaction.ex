defmodule Chargebeex.Fixtures.Transaction do
  def transaction_params do
    ~S"""
    {
      "id": "txn_198MNoUnquciBdDf",
      "customer_id": "7669f06b-31e7-4904-b281-2602e2f4e9cc",
      "subscription_id": "BTcefKUMlCZRiIXR",
      "gateway_account_id": "gw_199LRXTvbAey71Mi",
      "payment_source_id": "pm_BTcefKUMlCrvUIhb",
      "payment_method": "card",
      "gateway": "stripe",
      "type": "payment",
      "date": 1749679441,
      "exchange_rate": 1.0,
      "amount": 15339,
      "id_at_gateway": "ch_3RYwkXHjIp8VnBKJ1WTHXkC9",
      "status": "success",
      "updated_at": 1749679442,
      "fraud_reason": "Payment complete.",
      "resource_version": 1749679442151,
      "deleted": false,
      "object": "transaction",
      "masked_card_number": "************4242",
      "currency_code": "EUR",
      "base_currency_code": "EUR",
      "amount_unused": 0,
      "linked_invoices": [
        {
          "invoice_id": "DE20257214",
          "applied_amount": 15339,
          "applied_at": 1749679442,
          "invoice_date": 1749679433,
          "invoice_total": 15339,
          "invoice_status": "paid"
        }
      ],
      "linked_refunds": [],
      "business_entity_id": "BTcXXMTqZddGWfc",
      "payment_method_details": "{\"card\":{\"first_name\":\"john\",\"last_name\":\"doe\",\"iin\":\"******\",\"last4\":\"4242\",\"funding_type\":\"credit\",\"expiry_month\":12,\"expiry_year\":2029,\"billing_addr1\":\"SS\",\"billing_city\":\"NEWJERSEY\",\"billing_country\":\"DE\",\"billing_zip\":\"22222\",\"masked_number\":\"************4242\",\"object\":\"card\",\"brand\":\"visa\"}}",
      "initiator_type": "merchant",
      "three_d_secure": false
    }
    """
  end

  def retrieve() do
    """
    {
      "transaction": #{transaction_params()}
    }
    """
  end
end
