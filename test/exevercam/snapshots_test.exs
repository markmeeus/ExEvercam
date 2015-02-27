

defmodule ExEvercam.SnapshotsTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes/snaphots")
    ExVCR.Config.filter_url_params(true)
    HTTPoison.start
    :ok
  end

  @test_camera_id "evercam-remembrance-camera"

  test "Create snapshot" do
    use_cassette "POST Snapshot" do
      {:ok, snapshot} = TestConfig.get |> ExEvercam.API.Snapshot.create(@test_camera_id, %{notes: "snapshot notes"}, false)
      assert snapshot.notes == "snapshot notes"
    end
  end

  test "Ge snapshots" do
    use_cassette "GET Snapshots" do
      {:ok, [snapshot | _]} = TestConfig.get |> ExEvercam.API.Snapshot.list(@test_camera_id, %{})
      assert snapshot.notes == "Evercam System"
    end
  end
end