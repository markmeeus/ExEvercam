defmodule EvercamEx.Mixfile do
  use Mix.Project

  def project do
    [app: :exevercam,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: app_list(Mix.env) ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poison, "~> 1.3"},
      {:exvcr, "~> 0.3", only: [:dev, :test]},
      {:dotenv, "~> 0.0.4", only: [:dev, :test]}
    ]
  end

  defp app_list(:dev), do: [:dotenv | app_list]
  defp app_list(:test), do: [:dotenv | app_list]
  defp app_list(_), do: app_list
  defp app_list, do: [:logger]
end
