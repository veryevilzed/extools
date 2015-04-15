defmodule Coins do
    import Kernel, except: [div: 2, rem: 2, to_string: 1]

    defstruct [ val: 0 ]
    
    def new(), do: %Coins{}
    def new(val) when is_integer(val), do: %Coins{ val: val * 100 }
    def new(val) when is_float(val), 
        do: new(:io_lib_format.fwrite_g(val) |> IO.iodata_to_binary)
    def new(val) when is_binary(val), do: parse(val)
    def new(val) when is_list(val), do: parse(List.to_string(val))
    def new(coins = %Coins{}), do: coins

    def as_coin(val) when is_integer(val), do: %Coins{ val: val }
    def as_coin(val), do: new(val) |> Coins.div(100)

    def to_integer(%Coins{ val: val }), do: val
    def to_string(%Coins{ val: val }), do: "#{get_sign(val)}#{Kernel.abs(Kernel.div(val, 100))}#{get_fract(val)}"
    def to_float(coin = %Coins{ val: _ }) do 
        {val, ""} = to_string(coin) |> Float.parse
        val
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


    defp parse("+" <> bin) do
        String.downcase(bin) |> parse_unsign
    end

    defp parse("-" <> bin) do
        num = String.downcase(bin) |> parse_unsign
        %{num | val: -1 * num.val}
    end

    defp parse(bin) do
        String.downcase(bin) |> parse_unsign
    end

    defp parse_unsign(bin) do
        {int, rest} = parse_digits(bin)
        {float, rest} = parse_float(rest)
        {exp, rest} = parse_exp(rest)

        if rest != "" or (int == [] and float == []) do
          throw("Parse error")
        else
          if int == [], do: int = '0'
          if exp == [], do: exp = '0'
          %Coins{ val: padding(List.to_integer(int ++ float), List.to_integer(exp) - length(float) + 2) }
        end
    end

    defp padding(i, 0), do: i
    defp padding(i, p) when p > 0, do: padding(i*10, p-1)
    defp padding(i, p) when p < 0, do: padding(Kernel.div(i,10), p+1)

    defp parse_float("." <> rest), do: parse_digits(rest)
    defp parse_float(bin), do: {[], bin}

    defp parse_exp(<< ?e, rest :: binary >>) do
        case rest do
          << sign, rest :: binary >> when sign in [?+, ?-] ->
            {digits, rest} = parse_digits(rest)
            {[sign|digits], rest}
          _ ->
            parse_digits(rest)
        end
    end

    defp parse_exp(bin) do
        {[], bin}
    end

    defp parse_digits(bin), do: parse_digits(bin, [])

    defp parse_digits(<< digit, rest :: binary >>, acc) when digit in ?0..?9 do
        parse_digits(rest, [digit|acc])
    end

    defp parse_digits(rest, acc) do
        {:lists.reverse(acc), rest}
    end


    def add(%Coins{ val: old }, %Coins{ val: val }) do
        %Coins{ val: old + val }
    end
    def add(%Coins{ val: old }, val) do
        new(old + new(val).val)
    end
    def sub(%Coins{ val: old }, %Coins{ val: val }) do
        %Coins{ val: old - val }
    end
    def sub(%Coins{ val: old }, val) do
        new(old - new(val).val)
    end
    def mul(old, val) do
        new(Coins.to_float(old) * val)
    end
    def div(old, val) do
        as_coin(Kernel.div(Coins.to_integer(old), val))
    end
    def rem(old, val) do
        as_coin(Kernel.rem(Coins.to_integer(old), val*100))
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