defmodule ExEvercam.API.Snapshot do

	def list(config, camera_id, options) do
		snapshots = ExEvercam.API.Web.send_request(:get, camera_id |> snapshots_url, config.credentials, options)
    {:ok, snapshots[:snapshots]}
	end

	def create(config, camera_id, snapshot, with_data) do
		{:ok, json} = Poison.encode(Map.merge(snapshot, %{with_data: with_data}))
    snapshots = ExEvercam.API.Web.send_request(:post,  camera_id |> snapshots_url,
    	json, config.credentials, %{})

    {:ok, hd(snapshots[:snapshots])}
	end

	defp snapshots_url(camera_id) do
		"cameras/#{camera_id}/recordings/snapshots"
	end
end