defmodule ExEvercam.API.Snapshot do
	def create(config, camera_id, snapshot, with_data) do
		{:ok, json} = Poison.encode(Map.merge(snapshot, %{with_data: with_data}))
    snapshots = ExEvercam.API.Web.send_request(:post, "cameras/" <> camera_id <> "/recordings/snapshots",
    	json, config.credentials, %{})

    {:ok, hd(snapshots[:snapshots])}
	end
end