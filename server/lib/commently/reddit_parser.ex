defmodule Commently.RedditParser do
  
  def parse(path) do
    url = "https://www.reddit.com/r/" <> Enum.join(path, "/")
    { :ok, response } = HTTPoison.get(url, [], [follow_redirect: true, timeout: 10_000])
    resource = Floki.find(response.body, ".nestedlisting .entry") |> List.first

    title = Floki.find(response.body, ".title.may-blank") |> Floki.text
    text = Floki.find(resource, ".usertext-body") |> Floki.raw_html
    by = Floki.find(resource, ".author") |> Floki.text

    %{ title: title, content: text, by: by, image: "https://www.redditstatic.com/circled-snoo-1x.png" }
  end

end