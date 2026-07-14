defmodule Chargebeex.BusinessEntity do
  use TypedStruct

  @resource "business_entity"
  use Chargebeex.Resource, resource: @resource, only: []

  @moduledoc """
  Struct that represent a Chargebee's API business entity resource.
  """

  @typedoc """
  "active" | "inactive"
  """
  @type status :: String.t()

  typedstruct do
    field :id, String.t()
    field :name, String.t()
    field :status, status()
    field :deleted, boolean()
    field :resource_version, non_neg_integer()
    field :created_at, non_neg_integer()
    field :updated_at, non_neg_integer()
    field :resources, map(), default: %{}
  end

  use ExConstructor, :build

  @doc """
  Allows to transfer resources from one Business Entity to another.

  ## Examples

      iex> Chargebeex.BusinessEntity.transfer(%{
        active_resource_ids: ["11111111-2222-3333-4444-555555555555"],
        destination_business_entity_ids: ["AzXY00faketity01"],
        reason_codes: ["Correction"]
      })
      {:ok, %Chargebeex.BusinessEntity{}}
  """
  def transfer(params, opts \\ []) do
    generic_action_without_id(:post, @resource, "transfers", params, opts)
  end
end
