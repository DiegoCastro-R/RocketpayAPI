defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, result}) do
    result =
      result
      # Splita os dados recebidos no arquivo.
      |> String.split(",")
      # Mapeia os dados splitados e transforma em Inteiros
      |> Stream.map(fn number -> String.to_integer(number) end)
      # Soma
      |> Enum.sum()

    # Retorna o resultado
    {:ok, %{result: result}}
  end

  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid file!"}}
end
