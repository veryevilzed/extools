defmodule CoinsTest do
  use ExUnit.Case

  test "integer representation" do
    assert Coins.to_integer( Coins.new(1) ) == 100
    assert Coins.to_integer( Coins.new(10) ) == 1000
    assert Coins.to_integer( Coins.new(100) ) == 10000
    assert Coins.to_integer( Coins.new(1000) ) == 100000

    assert Coins.to_integer( Coins.new(1.0) ) == 100
    assert Coins.to_integer( Coins.new(10.0) ) == 1000
    assert Coins.to_integer( Coins.new(100.0) ) == 10000
    assert Coins.to_integer( Coins.new(0.1) ) == 10
    assert Coins.to_integer( Coins.new(0.01) ) == 1
    assert Coins.to_integer( Coins.new(0.001) ) == 0

    assert Coins.to_integer( Coins.new(1.1) ) == 110
    assert Coins.to_integer( Coins.new(1.11) ) == 111
    assert Coins.to_integer( Coins.new(1.01) ) == 101
    assert Coins.to_integer( Coins.new(1.011) ) == 101
    assert Coins.to_integer( Coins.new(1.019) ) == 101
    assert Coins.to_integer( Coins.new(1.01999) ) == 101

    assert Coins.to_integer( Coins.new(1234567.14) ) == 123456714
    assert Coins.to_integer( Coins.new(1234567.149999) ) == 123456714
    assert Coins.to_integer( Coins.new(1234567.140001) ) == 123456714

    assert Coins.to_integer( Coins.new("1") ) == 100
    assert Coins.to_integer( Coins.new("1.1") ) == 110
    assert Coins.to_integer( Coins.new("1.11") ) == 111
    assert Coins.to_integer( Coins.new("1.01") ) == 101
    assert Coins.to_integer( Coins.new("1.011") ) == 101
    assert Coins.to_integer( Coins.new("1.019") ) == 101
    assert Coins.to_integer( Coins.new("1.01999") ) == 101

    assert Coins.to_integer( Coins.new("1.99") ) == 199
    assert Coins.to_integer( Coins.new("1.999") ) == 199
    assert Coins.to_integer( Coins.new("1.9999") ) == 199

    assert Coins.to_integer( Coins.new("1.0e1") ) == 1000
    assert Coins.to_integer( Coins.new("1.0e-1") ) == 10
    assert Coins.to_integer( Coins.new("1.01e1") ) == 1010

    assert Coins.to_integer( Coins.new("1.001e3") ) == 100100
    assert Coins.to_integer( Coins.new("1.0001e3") ) == 100010
    assert Coins.to_integer( Coins.new("1.001e-2") ) == 1
  end

  test "negative representation" do
    assert Coins.to_integer( Coins.new(-1) ) == -100
    assert Coins.to_integer( Coins.new(-10) ) == -1000
    assert Coins.to_integer( Coins.new(-100) ) == -10000
    assert Coins.to_integer( Coins.new(-1000) ) == -100000

    assert Coins.to_integer( Coins.new(-1.0) ) == -100
    assert Coins.to_integer( Coins.new(-10.0) ) == -1000
    assert Coins.to_integer( Coins.new(-100.0) ) == -10000
    assert Coins.to_integer( Coins.new(-0.1) ) == -10
    assert Coins.to_integer( Coins.new(-0.01) ) == -1
    assert Coins.to_integer( Coins.new(-0.001) ) == 0

    assert Coins.to_integer( Coins.new(-1.1) ) == -110
    assert Coins.to_integer( Coins.new(-1.11) ) == -111
    assert Coins.to_integer( Coins.new(-1.01) ) == -101
    assert Coins.to_integer( Coins.new(-1.011) ) == -101
    assert Coins.to_integer( Coins.new(-1.019) ) == -101
    assert Coins.to_integer( Coins.new(-1.01999) ) == -101

    assert Coins.to_integer( Coins.new("-1") ) == -100
    assert Coins.to_integer( Coins.new("-1.1") ) == -110
    assert Coins.to_integer( Coins.new("-1.11") ) == -111
    assert Coins.to_integer( Coins.new("-1.01") ) == -101
    assert Coins.to_integer( Coins.new("-1.011") ) == -101
    assert Coins.to_integer( Coins.new("-1.019") ) == -101
    assert Coins.to_integer( Coins.new("-1.01999") ) == -101

    assert Coins.to_integer( Coins.new("-1.99") ) == -199
    assert Coins.to_integer( Coins.new("-1.999") ) == -199
    assert Coins.to_integer( Coins.new("-1.9999") ) == -199    
  end

  test "to string representation" do
    assert Coins.to_string( Coins.new(1) ) == "1.00"
    assert Coins.to_string( Coins.new(10) ) == "10.00"
    assert Coins.to_string( Coins.new(100) ) == "100.00"
    assert Coins.to_string( Coins.new(1000) ) == "1000.00"

    assert Coins.to_string( Coins.new(1.1) ) == "1.10"
    assert Coins.to_string( Coins.new(1.11) ) == "1.11"
    assert Coins.to_string( Coins.new(1.01) ) == "1.01"
    assert Coins.to_string( Coins.new(1.011) ) == "1.01"
    assert Coins.to_string( Coins.new(1.019) ) == "1.01"
    assert Coins.to_string( Coins.new(1.01999) ) == "1.01"

    assert Coins.to_string( Coins.new("1") ) == "1.00"
    assert Coins.to_string( Coins.new("1.1") ) == "1.10"
    assert Coins.to_string( Coins.new("1.11") ) == "1.11"
    assert Coins.to_string( Coins.new("1.01") ) == "1.01"
    assert Coins.to_string( Coins.new("1.011") ) == "1.01"
    assert Coins.to_string( Coins.new("1.019") ) == "1.01"
    assert Coins.to_string( Coins.new("1.01999") ) == "1.01"

    assert Coins.to_string( Coins.new("1.99") ) == "1.99"
    assert Coins.to_string( Coins.new("1.999") ) == "1.99"
    assert Coins.to_string( Coins.new("1.9999") ) == "1.99"
  end

  test "inspect representation" do
    assert inspect( Coins.new("1.01999") ) == "#Coins<1.01>"
  end

  test "operations" do
    assert Coins.add(Coins.new("1.11"), Coins.new("1.11")) == Coins.new("2.22")
    assert Coins.add(Coins.new("1.11"), Coins.new(1.11)) == Coins.new("2.22")
    assert Coins.add(Coins.new("1.11"), Coins.new(111)) == Coins.new("112.11")

    assert Coins.sub(Coins.new("1.11"), Coins.new("1.11")) == Coins.new("0")
    assert Coins.sub(Coins.new("1.11"), Coins.new(1.11)) == Coins.new("0")
    assert Coins.sub(Coins.new("111"),  Coins.new(111)) == Coins.new("0")

    assert Coins.mul(Coins.new("1.11"), 2) == Coins.new("2.22")

    assert Coins.div(Coins.new("2.22"), 2) == Coins.new("1.11")
    assert Coins.div(Coins.new("3.33"), 2) == Coins.new("1.66")

    assert Coins.rem(Coins.new("2.22"), 2) == Coins.new("0.22")
  end

end
