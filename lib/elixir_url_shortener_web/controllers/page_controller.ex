defmodule ElixirUrlShortenerWeb.PageController do
  use ElixirUrlShortenerWeb, :controller
  alias ElixirUrlShortener

  def index(conn, _params) do
    render conn, "index.html"
  end
  
  def shorten_url(conn, params) do
    long_url = params["long_url"]
    shortened_url = %ElixirUrlShortener{short_code: ElixirUrlShortener.random_short_code, long_url: long_url}
    render( conn, "shorten_url.html", shortened_url: shortened_url)
  end
end
