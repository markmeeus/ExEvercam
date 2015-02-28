defmodule ExEvercam.API.Snapshot do
  @doc """
  Returns the list of all snapshots currently stored for this camera
  """
  def list(config, camera_id, options \\ %{}) do
    snapshots = ExEvercam.API.Web.send_request(:get, camera_id |> snapshots_url, config.credentials, options)
    {:ok, snapshots[:snapshots]}
  end

  @doc """
  Returns the snapshot stored for this camera closest to the given timestamp
  """
  def get_at(config, camera_id, timestamp, with_data, range, options \\ %{}) do
    url = camera_id |> snapshot_url(timestamp)
    options = %{with_data: with_data, range: range} |> Map.merge(options)
    snapshots = ExEvercam.API.Web.send_request(:get, url, config.credentials, options)
    {:ok, hd(snapshots[:snapshots])}
  end

  @doc """
  Returns latest snapshot stored for this camera
  """
  def get_latest(config, camera_id, with_data) do
    url = camera_id |> latest_snapshot_url
    options = %{with_data: with_data}
    snapshots = ExEvercam.API.Web.send_request(:get, url, config.credentials, options)
    {:ok, hd(snapshots[:snapshots])}
  end

  @doc """
  Fetches a snapshot from the camera and stores it using the current timestamp
  """
  def create(config, camera_id, snapshot, return_data) do
    {:ok, json} = snapshot |> Map.merge(%{with_data: return_data}) |> Poison.encode()
    url = camera_id |> snapshots_url
    snapshots = ExEvercam.API.Web.send_request(:post, url, json, config.credentials, %{})

    {:ok, hd(snapshots[:snapshots])}
  end

  @doc """
  Stores the supplied snapshot image data for the given timestamp
  """
  def store(config, camera_id, timestamp, snapshot, return_data) when is_number(timestamp) do
    {:ok, json} = snapshot |> Map.merge(%{with_data: return_data}) |> Poison.encode()
    url =  camera_id |> snapshot_url(timestamp)
    snapshots = ExEvercam.API.Web.send_request(:post, url, json, config.credentials, %{})

    {:ok, hd(snapshots[:snapshots])}
  end

  defp snapshots_url(camera_id) do
    "cameras/#{camera_id}/recordings/snapshots"
  end

  defp snapshot_url(camera_id, timestamp) do
    "#{snapshots_url(camera_id)}/#{timestamp}"
  end

  defp latest_snapshot_url(camera_id) do
    "#{snapshots_url(camera_id)}/latest"
  end
end