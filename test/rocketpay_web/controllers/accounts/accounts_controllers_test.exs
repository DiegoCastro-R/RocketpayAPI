defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true
  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "User",
        password: "123456",
        nickname: "usernick",
        email: "usermail@valid.com",
        age: 23
      }

      {:ok, %User{account: %Account{id: accouunt_id}}} = Rocketpay.create_user(params)
      conn = put_req_header(conn, "authorization", "Basic ZGllZ286MTIzNDU2")
      {:ok, conn: conn, account_id: accouunt_id}
    end

    test "when all params are valid, deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => "Ballance changed succesfully"
             } = response
    end

    test "when there are invalid params,returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "NuM"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expeceted_response = %{"message" => "Invalid deposit value!"}

      assert response == expeceted_response
    end
  end
end
