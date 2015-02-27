defmodule ExEvercam.API.Camera do

  @doc """
  GET /cameras Returns data for a specified set of cameras.
  """
  def list(config, options \\ %{}) do
    cameras = ExEvercam.API.Web.send_request(:get, "cameras", config.credentials, options)
    {:ok, cameras[:cameras]}
  end

  @doc """
  Returns all data for a given camera
  """

  def get(config, id, options \\ %{}) do
    cameras = ExEvercam.API.Web.send_request(:get, "cameras/" <> to_string(id) , config.credentials, options)
    {:ok, hd(cameras[:cameras])}
  end

  @doc """
  Creates a new camera owned by the authenticating user
  """
  def create(config, camera) do
    {:ok, json} = Poison.encode(camera)
    cameras = ExEvercam.API.Web.send_request(:post, "cameras", json, config.credentials, %{})
    {:ok, cameras[:cameras]}
  end

  @doc """
  Updates full or partial data for an existing camera
  """
  def update(config, camera) do
    {:ok, json} = Poison.encode(camera)
    cameras = ExEvercam.API.Web.send_request(:patch, "cameras/" <> to_string(camera.id), json, config.credentials, %{})
    {:ok, cameras[:cameras]}
  end

  @doc """
  Deletes a camera from Evercam along with any stored media
  """
  def delete(config, id) do
    {:ok, _response} = ExEvercam.API.Web.send_request(:delete, "cameras/" <> to_string(id), config.credentials, %{})
    :ok
  end


  def get_live_snapshot(config, camera_id) do
    snapshot = ExEvercam.API.Web.send_request(:get, "cameras/" <> to_string(camera_id) <> "/live/snapshot", config.credentials, %{expect_binary: true})
    {:ok, snapshot}
  end

  def get_logs(config, camera_id) do
    logs = ExEvercam.API.Web.send_request(:get, "cameras/" <> to_string(camera_id) <> "/logs" , config.credentials, %{})
    {:ok, logs[:logs]}
  end
end