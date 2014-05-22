defmodule ExTools do

    defp to_map([{k,v}|list]) when is_list(list) do
        [{k,v}|list] |> Enum.reduce %{}, fn({key, value}, acc) -> Dict.put acc, key, to_map(value); end
    end

    defp to_map(list) when is_list(list), do: list

    defp to_map(list), do: list

    def parse(text) do
        case :etoml.parse(text) do
            {:ok, toml} -> {:ok, to_map(toml) }
            err -> err
        end
    end

    @doc """
    Переводит Dict старого стиля в Map
    """
    def dict_to_map(dict), do: to_map(toml)

    def binary_to_atom(bin) when is_atom(bin), do: bin
    def binary_to_atom(bin) when is_binary(bin), do: binary_to_atom(bin)

    def binary_to_list(bin) when is_list(bin), do: bin
    def binary_to_list(bin) when is_binary(bin), do: :erlang.binary_to_list(bin)


end
