defmodule Micon.SvgTest do
  use ExUnit.Case

  test("Svg boots up and generages icon symbols") do
    svgs = Micon.Svg.all()
    assert length(svgs) == 3
  end

end
