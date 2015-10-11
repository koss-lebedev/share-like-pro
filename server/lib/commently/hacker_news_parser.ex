defmodule Commently.HackerNewsParser do
  
  def parse(path) do
    url = "https://news.ycombinator.com/item?id=#{path}"
    { :ok, response } = HTTPoison.get(url, [], [follow_redirect: true])

    title = Floki.find(response.body, ".storyon > a") |> Floki.text
    text = Floki.find(response.body, ".comment") |> Floki.raw_html
    by = Floki.find(response.body, ".hnuser") |> Floki.text

    %{ title: title, content: text, by: by, image: "http://www.ycombinator.com/images/ycombinator-logo-fb889e2e.png" }
  end

end