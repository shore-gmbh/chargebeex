defmodule Chargebeex.Fixtures.BusinessEntity do
  def business_entity_params() do
    """
    {
      "id": "AzXY00faketity01",
      "name": "Acme Inc",
      "status": "active",
      "deleted": false,
      "resource_version": 1608209339000,
      "created_at": 1608209339,
      "updated_at": 1608209339
    }
    """
  end

  def retrieve() do
    """
    {
      "business_entity": #{business_entity_params()}
    }
    """
  end

  def list() do
    """
    {
      "list": [
        #{retrieve()},
        #{retrieve()}
      ],
      "next_offset": "1612890918000"
    }
    """
  end
end
