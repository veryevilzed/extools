defmodule ExTools do

    defp _to_map([{k,v}|list]) when is_list(list) do
        [{k,v}|list] |> Enum.reduce %{}, fn({key, value}, acc) -> Dict.put acc, key, to_map(value); end
    end

    defp _to_map(list) when is_list(list), do: list

    defp _to_map(list), do: Enum.map _to_map(list)

    @doc """
    Переводит Dict старого стиля в Map
    """
    def to_map(dict), do: _to_map(dict)

    def bin_to_atom(bin) when is_atom(bin), do: bin
    def bin_to_atom(bin) when is_binary(bin), do: Kernel.binary_to_atom(bin)

    def bin_to_list(bin) when is_list(bin), do: bin
    def bin_to_list(bin) when is_binary(bin), do: :erlang.binary_to_list(bin)


end
