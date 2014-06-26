defmodule ExTools do

    defp _to_map([{k,v}|list]) when is_list(list) do
        [{k,v}|list] |> Enum.reduce %{}, fn({key, value}, acc) -> Dict.put acc, key, to_map(value); end
    end

    defp _to_map(list) when is_list(list), do: list |> Enum.map &(_to_map(&1))

    defp _to_map(item), do: item 

    @doc """
    Переводит Dict старого стиля в Map
    """
    def to_map(dict), do: _to_map(dict)

    def bin_to_atom(bin), do: to_atom(bin)

    def bin_to_list(bin) when is_list(bin), do: bin
    def bin_to_list(bin) when is_binary(bin), do: :erlang.binary_to_list(bin)

    defp parse_res({p, _}), do: p

    def to_integer(v) when is_integer(v), do: v
    def to_integer(v) when is_binary(v), do: Integer.parse(v) |> parse_res
    def to_integer(v) when is_float(v), do: Float.ceil v

    def to_binary(v) when is_binary(v), do: v
    def to_binary(v) when is_integer(v), do: "#{v}"
    def to_binary(v) when is_atom(v), do: Atom.to_string v
    def to_binary(v) when is_float(v), do: Float.to_string v
    def to_binary(v) when is_list(v), do: "#{inspect v}"
    def to_binary(v) when is_map(v), do: "#{inspect v}"


    def to_float(v) when is_float(v), do: v
    def to_float(v) when is_integer(v), do: v * 1.0
    def to_float(v) when is_binary(v), do: Float.parse(v) |> parse_res

    def to_atom(v) when is_atom(v), do: v
    def to_atom(v) when is_binary(v), do: String.to_atom v

end
