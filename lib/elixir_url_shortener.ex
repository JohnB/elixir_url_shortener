defmodule ElixirUrlShortener do
  @moduledoc """
    Global singleton holding short-to-long mappings
  """
  
  use GenServer
  defstruct [:short_code, :long_url]
  
  def start_link(_opts \\ []) do
    case GenServer.start_link(__MODULE__, :ok, name: {:global, __MODULE__}) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end

  # Client side
  def create_short_code(long_url) do
    {:ok, our_pid} = start_link()
    GenServer.call(our_pid, {:create_short_code, long_url})
  end
  def lookup_long_url(short_code) do
    {:ok, our_pid} = start_link()
    GenServer.call(our_pid, {:lookup_long_url, short_code})
  end

  # Server side
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:create_short_code, long_url}, _from, state) do
    short_code = random_short_code()
    shortener = %ElixirUrlShortener{short_code: short_code, long_url: long_url}
    state = Map.put(state, short_code, shortener)
    {:reply, short_code, state}
  end

  def handle_call({:lookup_long_url, short_code}, _from, state) do
    {:reply, Map.fetch(state, short_code), state}
  end
  
  @short_code_length 8
  @valid_short_characters [
    "A", "B", "C", "D", "E",
    "F", "G", "H", "J", "K",
    "M", "N", "P", "Q", "R",
    "S", "T", "W", "X", "Y",
    "3", "4", "6", "7", "9"
  ]

  # The "internal" function seems like a cheat - but it was the only
  # way to make it work for all lengths.
  def random_short_code(size \\ @short_code_length) do
    random_short_code_internal(size - 1) |> Enum.join
  end

  defp random_short_code_internal(size) when size < 0 do
    []
  end
  defp random_short_code_internal(size) do
    [Enum.random(@valid_short_characters) | random_short_code_internal(size - 1)]
  end
end
