defmodule Lux.Rust do
  @moduledoc """
  Provides functions for executing high-performance Rust code via NIFs.
  """

  use Rustler, otp_app: :lux, crate: "lux_native"

  @doc """
  Evaluates a simple expression or task in Rust.
  This is a placeholder for the native implementation.
  """
  def evaluate(_task, _input), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Checks if the Rust NIFs are loaded and available.
  """
  def loaded?, do: true
end
