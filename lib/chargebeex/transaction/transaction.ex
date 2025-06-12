defmodule Chargebeex.Transaction do
  use TypedStruct

  @resource "transaction"
  use Chargebeex.Resource, resource: @resource, only: [:list, :retrieve]

  @moduledoc """
  Struct that represent a Chargebee's API transaction resource.
  """

  typedstruct do
    field :id, String.t()
    field :customer_id, String.t()
    field :subscription_id, String.t()
    field :gateway_account_id, String.t()
    field :payment_source_id, String.t()
    field :payment_method, String.t()
    field :reference_number, String.t()
    field :gateway, String.t()
    field :type, String.t()
    field :date, non_neg_integer()
    field :settled_at, non_neg_integer()
    field :exchange_rate, non_neg_integer()
    field :currency_code, String.t()
    field :base_currency_code, String.t()
    field :amount, non_neg_integer()
    field :id_at_gateway, String.t()
    field :status, String.t()
    field :fraud_flag, String.t()
    field :initiator_type, String.t()
    field :three_d_secure, boolean()
    field :authorization_reason, String.t()
    field :error_code, String.t()
    field :error_text, String.t()
    field :voided_at, non_neg_integer()
    field :resource_version, integer()
    field :updated_at, non_neg_integer()
    field :fraud_reason, String.t()
    field :custom_payment_method_id, String.t()
    field :amount_unused, non_neg_integer()
    field :masked_card_number, String.t()
    field :reference_transaction_id, String.t()
    field :refunded_txn_id, String.t()
    field :reference_authorization_id, String.t()
    field :amount_capturable, non_neg_integer()
    field :reversal_transaction_id, String.t()
    field :deleted, boolean()
    field :iin, String.t()
    field :last4, String.t()
    field :merchant_reference_id, String.t()
    field :business_entity_id, String.t()
    field :payment_method_details, map()
    field :custom_payment_method_name, String.t()
    field :linked_invoices, [Chargebeex.Invoice.t()]
    field :linked_credit_notes, [Chargebeex.CreditNote.t()]
    field :linked_refunds, [Chargebeex.Refund.t()]
    field :linked_payments, [Chargebeex.Payment.t()]
    field :error_detail, Chargebeex.ErrorDetail.t()
    field :resources, map(), default: %{}

    field :object, String.t()
  end

  use ExConstructor, :build
end
