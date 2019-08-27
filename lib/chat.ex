defmodule Chat do
  def start do
    {host, port} = get_host_and_port()
    IO.inspect(host)
    IO.inspect(port)
  end

  defp get_host_and_port do
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
