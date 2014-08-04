defmodule Coins do
    import Kernel, except: [div: 2, rem: 2]

    defstruct [ val: 0 ]
    
    def new(), do: %Coins{}
    def new(val) when is_integer(val), do: %Coins{ val: val }
    def new(val) when is_float(val) and val >= 0, 
        do: %Coins{ val: Float.floor(Float.round(val * 100, 7)) }
    def new(val) when is_float(val), 
        do: %Coins{ val: Float.ceil(Float.round(val * 100, 7)) }
    def new(val) when is_binary(val), do: parse_str_sign(val)
    def new(coins = %Coins{}), do: coins

    defp parse_str_sign("-" <> str), do: inverse( parse_str_sign(str) )
    defp parse_str_sign("+" <> str), do: parse_str_sign(str)
    defp parse_str_sign(str) do 
        case Integer.parse(str) do
            {whole, ""} -> %Coins{ val: whole * 100 }
            {whole, "."} -> %Coins{ val: whole * 100 }
            {whole, "." <> fract} -> 
                case Integer.parse(String.slice(fract <> "0", 0, 2)) do
                    {fract, ""} -> %Coins{ val: whole * 100 + fract }
                    _ -> throw("Parse error")
                end   
            _ -> throw("Parse error")
        end
    end

    defp inverse(%Coins{ val: val }) do
        %Coins{ val: -1 * val }
    end

    def to_integer(%Coins{ val: val }) do
        val
    end

    def to_string(%Coins{ val: val }) do
        "#{get_sign(val)}#{Kernel.abs(Kernel.div(val, 100))}#{get_fract(val)}"
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