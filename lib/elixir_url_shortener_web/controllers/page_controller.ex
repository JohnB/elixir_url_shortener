defmodule ElixirUrlShortenerWeb.PageController do
  use ElixirUrlShortenerWeb, :controller
  alias ElixirUrlShortener

  def index(conn, params) do
    render(conn, "index.html")
  end
  
  def use_short_code(conn, params) do
    short_code = params["short_code"]
    long_url = ElixirUrlShortener.lookup_long_url(short_code)
    case long_url do
      :error -> Phoenix.View.render text(conn, "NOT FOUND")
      {:ok, shortener} -> redirect(conn, external: shortener.long_url)
      _ -> Phoenix.View.render text(conn, "INTERNAL ERROR")
    end
  end
  
  def shorten_url(conn, params) do
    long_url = params["long_url"]
        
    shortened_url = ElixirUrlShortener.create_short_code(long_url)
    render( conn, "shorten_url.html", shortened_url: shortened_url)
  end
end
