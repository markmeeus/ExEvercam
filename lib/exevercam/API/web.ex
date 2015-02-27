defmodule ExEvercam.API.Web do
  @base_url "https://api.evercam.io/v1/"

  def send_request(:get, path, credentials, %{expect_binary: true} = options) do
    all_params = Map.merge(options, credentials)
    {:ok, response} = build_url(path) |> HTTPoison.get([], params: all_params, hackney: [follow_redirect: true])
    response.body
  end

  def send_request(:get, path, credentials, options ) do
    all_params = Map.merge(options, credentials)
    build_url(path) |> HTTPoison.get([], params: all_params, hackney: [follow_redirect: true]) |> response_to_json |> parse!
  end


  def send_request(:delete, path, credentials, options) do
    all_params = Map.merge(options, credentials)
    build_url(path) |> HTTPoison.delete([], params: all_params)
  end

  def send_request(:post, path, data, credentials, options) do
    all_params = Map.merge(options, credentials)
    build_url(path) |> HTTPoison.post(data, [], params: all_params) |> response_to_json |> parse!
  end

  def send_request(:patch, path, data, credentials, options) do
    all_params = Map.merge(options, credentials)
    build_url(path) |> HTTPoison.patch(data, [], params: all_params) |> response_to_json |> parse!
  end


  defp build_url(path) do
    "#{@base_url}/#{path}"
  end

  defp response_to_json({:ok, response}) do
    response.body
  end

  defp parse!(json) do
    Poison.Parser.parse!(json, keys: :atoms)
  end
end