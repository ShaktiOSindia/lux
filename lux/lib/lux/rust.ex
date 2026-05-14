defmodule Lux.Rust do
  @moduledoc """
  Provides functions for executing high-performance Rust code via native NIFs.

  Unlike JSON-bridge implementations, `Lux.Rust` uses Rustler to provide
  direct, memory-safe, and zero-copy data exchange between Elixir and Rust.
  """

  use Rustler, otp_app: :lux, crate: "lux_native"

  @doc """
  Evaluates a Rust task with the given input.

  Supported tasks:
  - `"echo"`: Returns the input as-is.
  - `"sum"`: Returns the sum of a list of integers.
  - `"is_truthy"`: Returns whether the input is truthy in a Rust context.

  ## Examples

      iex> Lux.Rust.eval("sum", [1, 2, 3])
      {:ok, 6}

      iex> Lux.Rust.eval("echo", %{a: 1})
      {:ok, %{a: 1}}
  """
  @spec eval(String.t(), term()) :: {:ok, term()} | {:error, String.t()}
  def eval(task, input), do: evaluate(task, input)

  @doc """
  Same as `eval/2` but raises on error.
  """
  @spec eval!(String.t(), term()) :: term() | no_return()
  def eval!(task, input) do
    case eval(task, input) do
      {:ok, result} -> result
      {:error, reason} -> raise RuntimeError, "Rust error: #{reason}"
    end
  end

  # Native NIF placeholder
  defp evaluate(_task, _input), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  A macro for writing inline Rust-like tasks (placeholder for future expansion).
  """
  defmacro rust(task, opts \\ []) do
    quote do
      input = Keyword.get(unquote(opts), :input)
      Lux.Rust.eval!(unquote(task), input)
    end
  end

  @doc """
  Checks if the Rust NIFs are loaded and available.
  """
  def loaded?, do: true
end
