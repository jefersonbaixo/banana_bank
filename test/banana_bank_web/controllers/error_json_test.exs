defmodule BananaBankWeb.ErrorJSONTest do
  use BananaBankWeb.ConnCase, async: true

  test "renders 404" do
    assert BananaBankWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BananaBankWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  test "renders 400" do
    assert BananaBankWeb.ErrorJSON.render("400.json", %{}) ==
             %{errors: %{detail: "Bad Request"}}
  end
end
