defmodule Chat do
  def start do
    {host, port} = get_host_and_port()
    options = [mode: :binary, active: true, packet: 2]

    case :gen_tcp.connect(String.to_charlist(host), port, options) do
      {:ok, socket} ->
        IO.puts("Connection successful")
        listen(socket)

      {:error, reason} ->
        raise "Failed to open connection: #{inspect(reason)}"
    end
  end

  defp listen(socket) do
    receive do
      {:tcp, ^socket, data} ->
        data
        |> Jason.decode!()
        |> IO.inspect()
        |> handle_message()

        listen(socket)

      {:tcp_closed, ^socket} ->
        raise "TCP connection was closed"

      {:tcp_error, ^socket, reason} ->
        raise "TCP connection error: #{inspect(reason)}"
    end
  end

  defp handle_message(%{"kind" => "welcome"} = map) do
    IO.puts("Welcome to the ElixirConf server")
    users_online = map["users_online"]

    case users_online do
      nil ->
        raise "Error retrieving number of users"

      1 ->
        IO.puts("There is 1 user online")

      _ ->
        IO.puts("there are #{inspect(users_online)} users online")
    end
  end

  defp handle_message(unknown_message) do
    IO.puts("Received unknown message: #{inspect(unknown_message)}")
  end

  defp get_host_and_port() do
    address = String.trim(IO.gets("Server address (localhost:4000): "))

    case address do
      "" ->
        {"localhost", 4000}

      _ ->
        [host, port] = String.split(address, ":")
        port = String.to_integer(port)
        {host, port}
    end
  end
end
