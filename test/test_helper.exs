defmodule TestConfig do
  def get do
    %{
      credentials: %{api_id: System.get_env("EVERCAM_API_ID"), api_key: System.get_env("EVERCAM_API_KEY")}
    }
  end
end

ExUnit.start()
