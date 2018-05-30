defmodule ElixirUrlShortener do
  defstruct [:short_code, :long_url]

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
