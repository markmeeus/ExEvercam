

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

  test "Get snapshots" do
    use_cassette "GET Snapshots" do
      {:ok, [snapshot | _]} = TestConfig.get |> ExEvercam.API.Snapshot.list(@test_camera_id, %{})
      assert snapshot.notes == "Evercam System"
    end
  end

  test "Upload snapshot" do
    use_cassette "POST store snapshot" do
      #Test fails, probably needs multipart upload
      {:ok, data} = File.read("fixture/snapshot.jpg")
      data = data |> Base.encode64
      {:ok, [snapshot | _]} = TestConfig.get |> ExEvercam.API.Snapshot.store("12345-test-cam", 1425165778, %{notes: "snapshot notes", data: data}, false)
    end
  end

  test "Get snapshot around timestamp" do
    use_cassette "GET snapshot with timestamp" do
      {:ok, snapshot} = TestConfig.get |> ExEvercam.API.Snapshot.get_at(@test_camera_id, 1400606432, false, 60)
      assert snapshot.notes == "Evercam System"
    end
  end

  test "Get latest snapshot" do
    use_cassette "Get latest snapshot" do
      {:ok, snapshot} = TestConfig.get |> ExEvercam.API.Snapshot.get_latest(@test_camera_id, false)
      assert snapshot.notes == "Evercam System"
    end
  end

end