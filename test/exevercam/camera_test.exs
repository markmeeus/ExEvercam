defmodule ExEvercam.CameraTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_url_params(true)
    HTTPoison.start
    :ok
  end

  test "List cameras" do
    use_cassette "List cameras" do
      {:ok, cameras} = TestConfig.get |> ExEvercam.API.Camera.list(%{include_shared: true})

      assert is_list(cameras)

      camera = hd(cameras)
      assert camera.id == "evercam-remembrance-camera"

      assert camera.name == "Evercam Demo Rosslare"
      assert camera.owned == false
      assert camera.owner == "evercam"
      assert camera.vendor_id == "hikvision"
      assert camera.vendor_name == "Hikvision Digital Technology"
      assert camera.model_id == "hikvision_default"
      assert camera.model_name  == "Default"
      assert camera.timezone == "Europe/Dublin"
      assert camera.is_online == true
      assert camera.is_public == true
      assert camera.discoverable == true
      assert camera.location == %{lat: 52.25431308714678, lng: -6.335584562451231}
      assert camera.proxy_url == %{jpg: "http://evr.cm/evercam-remembrance-camera.jpg",rtmp: "rtmp://streams.evercam.io:1935/live/rtsp%3A%2F%2Fguest%3Aguest%40149.5.38.22%3A90%2Fh264%2Fch1%2Fmain%2Fav_stream"}
      assert camera.rights == "snapshot,list"
    end
  end

  test "Get camera by ID" do
    use_cassette "GET camera by id" do
      {:ok, camera} = TestConfig.get |> ExEvercam.API.Camera.get("12345-test-cam")
      assert camera.id == "12345-test-cam"
    end
  end

  test "Create camera" do
    use_cassette "POST camera" do
      camera = %{
          id: "12345-test-cam",
          name: "test camera",
          internal_host: "test.com",
          is_public: false
        }
      {:ok, [camera|_]} = TestConfig.get |> ExEvercam.API.Camera.create(camera)
      assert camera.id == "12345-test-cam"
    end
  end

  test "Update camera" do
    use_cassette "PATCH camera" do
      camera = %{
          id: "12345-test-cam",
          name: "test camera update",
          internal_host: "test.com",
          is_public: false
        }
      {:ok, camera} = TestConfig.get |> ExEvercam.API.Camera.update(camera)
    end
  end

  test "delete camera" do
    use_cassette "DELETE camera" do
      assert TestConfig.get |> ExEvercam.API.Camera.delete("12345-test-cam") == :ok
    end
  end

  test "Get Camera live snapshot" do
    use_cassette "GET live snapshot" do
      {:ok, snapshot} = TestConfig.get |> ExEvercam.API.Camera.get_live_snapshot("evercam-remembrance-camera")
      assert is_binary(snapshot)
    end
  end

  test "Get Camera logs" do
    use_cassette "Get camera logs" do
      {:ok, logs} = TestConfig.get |> ExEvercam.API.Camera.get_logs("evercam-remembrance-camera")
      assert is_list(logs)
      log1 = hd(logs)
      assert log1 == "[evercam-remembrance-camera] Anonymous viewed at 2015-02-27 16:06:18 +0000 from 109.131.162.16"
    end
  end
end