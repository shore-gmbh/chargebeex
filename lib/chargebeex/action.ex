defmodule Chargebeex.Action do
  @moduledoc false
  alias Chargebeex.Client
  alias Chargebeex.Builder

  def retrieve(resource, id, opts \\ []) do
    with path <- resource_path(resource, id),
         {:ok, _status_code, _headers, content} <- Client.get(path, %{}, opts),
         builded <- Builder.build(content) do
      {:ok, put_resources(builded, resource)}
    end
  end

  def list(resource, params \\ %{}, opts \\ []) do
    with path <- resource_base_path(resource),
         {:ok, _status_code, _headers, content} <- Client.get(path, params, opts),
         {builded, metadata} <- Builder.build(content) do
      {:ok, Enum.map(builded, &put_resources(&1, resource)), metadata}
    end
  end

  def create(resource, params, opts \\ []) do
    with path <- resource_base_path(resource),
         {:ok, _status_code, _headers, content} <- Client.post(path, params, opts),
         builded <- Builder.build(content) do
      {:ok, put_resources(builded, resource)}
    end
  end

  def update(resource, id, params, opts \\ []) do
    with path <- resource_path(resource, id),
         {:ok, _status_code, _headers, content} <- Client.post(path, params, opts),
         builded <- Builder.build(content) do
      {:ok, put_resources(builded, resource)}
    end
  end

  def delete(resource, id, opts \\ []) do
    with path <- delete_path(resource, id),
         {:ok, _status_code, _headers, content} <- Client.post(path, %{}, opts),
         builded <- Builder.build(content) do
      {:ok, put_resources(builded, resource)}
    end
  end

  def generic_action(verb, resource, action, id, params \\ %{}, opts \\ []) do
    with path <- resource_path_generic(resource, id, action),
         {:ok, _status_code, _headers, content} <- apply(Client, verb, [path, params, opts]),
         builded <- Builder.build(content) do
      {:ok, put_resources(builded, resource)}
    end
  end

  def generic_action_without_id(verb, resource, action, params \\ %{}, opts \\ []) do
    with path <- resource_path_generic_without_id(resource, action),
         {:ok, _status_code, _headers, content} <- apply(Client, verb, [path, params, opts]) do
      build_response(content, resource)
    end
  end

  def nested_generic_action_without_id(
        verb,
        nested_to,
        resource,
        action,
        params \\ %{},
        opts \\ []
      ) do
    with path <- nested_resource_path_generic_without_id(nested_to, action),
         {:ok, _status_code, _headers, content} <- apply(Client, verb, [path, params, opts]) do
      build_response(content, resource)
    end
  end

  # Builds the API response, handling both single-resource maps and paginated
  # list responses (which `Builder.build/1` returns as a `{list, metadata}` tuple).
  defp build_response(content, resource) do
    case Builder.build(content) do
      {builded, metadata} -> {:ok, Enum.map(builded, &put_resources(&1, resource)), metadata}
      builded -> {:ok, put_resources(builded, resource)}
    end
  end

  defp put_resources(builded, resource) do
    builded
    |> Map.get(resource, %{})
    |> Map.merge(%{resources: Map.drop(builded, [resource])})
  end

  def resource_base_path(resource) do
    "/#{pluralize(resource)}"
  end

  # Some Chargebee resources have irregular plural forms that cannot be built by
  # simply appending an "s" to the resource name.
  @irregular_plurals %{
    "business_entity" => "business_entities"
  }

  defp pluralize(resource) do
    Map.get(@irregular_plurals, resource, "#{resource}s")
  end

  def resource_path(resource, id) do
    "#{resource_base_path(resource)}/#{id}"
  end

  def resource_path_generic(resource, id, action) do
    Path.join([resource_base_path(resource), id, action])
  end

  def resource_path_generic_without_id(resource, action) do
    Path.join([resource_base_path(resource), action])
  end

  def nested_resource_path_generic_without_id(nested_to, action) do
    path = Enum.map(nested_to, fn {resource, id} -> resource_path(resource, id) end)
    Path.join(path ++ [action])
  end

  def delete_path(resource, id) do
    Path.join([resource_path(resource, id), "delete"])
  end
end
