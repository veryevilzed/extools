defmodule Coins do
    import Kernel, except: [div: 2, rem: 2]

    defstruct [ val: 0 ]
    
    def new(), do: %Coins{}
    def new(val) when is_integer(val), do: %Coins{ val: val }
    def new(val) when is_float(val), 
        do: new(:io_lib_format.fwrite_g(val) |> IO.iodata_to_binary)
    def new(val) when is_binary(val), do: parse_str_sign(val)
    def new(val) when is_list(val), do: parse_str_sign(List.to_string(val))
    def new(coins = %Coins{}), do: coins

    def to_integer(%Coins{ val: val }), do: val
    def to_string(%Coins{ val: val }), do: "#{get_sign(val)}#{Kernel.abs(Kernel.div(val, 100))}#{get_fract(val)}"
    def to_float(coin = %Coins{ val: _ }) do 
        {val, ""} = to_string(coin) |> Float.parse
        val
    end

    defp parse_str_sign("-" <> str), do: inverse( parse_str_sign(str) )
    defp parse_str_sign("+" <> str), do: parse_str_sign(str)
    defp parse_str_sign(str) do 
        case Integer.parse(str) do
            {whole, ""} -> %Coins{ val: whole * 100 }
            {whole, "."} -> %Coins{ val: whole * 100 }
            {whole, "e" <> exp} -> 
                case Integer.parse(exp) do
                    {exp, ""} -> %Coins{ val: padding_exp(exp+2, whole) }
                    _ -> throw("Parse error")
                end
                
            {whole, "." <> sfract} -> 
                {fract, exp} = case String.split(sfract, "e") do
                    [fract, exp] -> 
                        case Integer.parse(exp) do
                            {exp, ""} -> {padding_fract(fract), exp + 2}
                            _ -> throw("Parse error")
                        end
                    [fract] -> {padding_fract(fract), 2}
                    _ -> throw("Parse error")
                end
                %Coins{ val: padding_exp(exp - 2, whole * 100 + fract) }
            _ -> throw("Parse error")
        end
    end

    defp padding_fract(fract) do
        case {Integer.parse(String.slice(fract, 0..1)), String.length(fract)} do
            {_, 0} -> 0
            {{fract, ""}, 1} -> fract*10
            {{fract, ""}, _} -> fract
            _ -> throw("Parse error")
        end
    end

    defp padding_exp(0, i), do: i
    defp padding_exp(_, 0), do: 0
    defp padding_exp(exp, i) when exp < 0, do: padding_exp(exp+1, Kernel.div(i,10))
    defp padding_exp(exp, i), do: padding_exp(exp-1, i*10)

    defp inverse(%Coins{ val: val }) do
        %Coins{ val: -1 * val }
    end

    defp get_sign(val) when val < 0, do: "-"
    defp get_sign(_val), do: ""
    defp get_fract(val) do
        fract = Kernel.abs(Kernel.rem(val, 100))
        cond do
            fract >= 10 -> ".#{fract}"
            fract > 0 -> ".0#{fract}"
            true -> ".00"
        end        
    end 

    def add(%Coins{ val: old }, val) do
        new(old + new(val).val)
    end
    def sub(%Coins{ val: old }, val) do
        new(old - new(val).val)
    end
    def mul(%Coins{ val: old }, val) do
        new(old * new(val).val)
    end
    def div(%Coins{ val: old }, val) do
        new(Kernel.div(old, new(val).val))
    end
    def rem(%Coins{ val: old }, val) do
        new(Kernel.rem(old, new(val).val))
    end
end


defimpl Inspect, for: Coins do
    def inspect(coins, _opts) do
        "#Coins<" <> Coins.to_string(coins) <> ">"
    end
end

defimpl String.Chars, for: Coins do
    def to_string(coins) do
        Coins.to_string(coins)
    end
end