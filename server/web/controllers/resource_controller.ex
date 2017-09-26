defmodule Commently.ResourceController do
  use Commently.Web, :controller

  plug :put_layout, false

  #
  # Renders image for Reddit
  #
  def show(conn, %{"resource" => "reddit", "path" => path}) do
    render(conn, "show.html", get_reddit_info(path))
  end

  #
  # Renders image for HN
  #
  def show(conn, %{"resource" => "hn", "path" => path}) do
    render(conn, "show.html", get_hn_info(path))
  end

  #
  # GET page for Reddit comment
  #
  def new(conn, %{"resource" => "reddit", "path" => path}) do
    current_user = get_session(conn, :current_user)
    case current_user do
      nil -> conn |> put_session(:return_url, conn.request_path) |> redirect(to: "/auth/twitter")
      _ ->
        render(conn, "post.html")
    end
  end

  #
  # GET page for Reddit comment
  #
  def new(conn, %{"resource" => "hn", "path" => path}) do
    current_user = get_session(conn, :current_user)
    case current_user do
      nil -> conn |> put_session(:return_url, conn.request_path) |> redirect(to: "/auth/twitter")
      _ ->
        render(conn, "post.html")
    end
  end

  #
  # POST page for Reddit comment
  #
  def create(conn, %{"resource" => "reddit", "path" => path, "message" => message}) do
    current_user = get_session(conn, :current_user)
    case current_user do
      nil -> redirect(conn, to: "/")
      _ ->
        share_link(message, "reddit", path, current_user)
        render(conn, "done.html")
    end
  end

  #
  # POST page for HN comment
  #
  def create(conn, %{"resource" => "hn", "path" => path, "message" => message}) do
    current_user = get_session(conn, :current_user)
    case current_user do
      nil -> redirect(conn, to: "/")
      _ ->
        share_link(message, "hn", path, current_user)
        render(conn, "done.html")
    end
  end

  defp share_link(message, resource, path, user) do
    preview_url = "http://#{System.get_env("HOST") || "localhost:4000"}/#{resource}/comments/#{Enum.join(path, "/")}"

    IO.puts "*** Fetching HTML... ***"
    { :ok, response } = HTTPoison.get(preview_url, [], [ follow_redirect: true ])

    IO.puts "*** HTML fetched. Generating image... ***"
    { :ok, contents } = HtmlToImage.convert(response.body, width: 843, format: :png)
    media = IO.iodata_to_binary(contents)

    IO.puts "*** Image generated. Posting to Twitter... ***"
    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: user.token,
      access_token_secret: user.secret
    )

    ExTwitter.update_with_media(message, media)
    IO.puts "*** Posted to Twitter. ***"

    changeset = Commently.User.changeset(user, %{ share_count: user.share_count + 1 })
    Commently.Repo.update(changeset)
  end

  defp get_hn_info(path) do
    url = "https://news.ycombinator.com/item?id=#{path}"
    { :ok, response } = HTTPoison.get(url, [], [follow_redirect: true])

    title = Floki.find(response.body, ".storyon > a") |> Floki.text
    text = Floki.find(response.body, ".comment") |> Floki.raw_html
    by = Floki.find(response.body, ".hnuser") |> Floki.text

    %{ title: title, content: text, by: by, image: "http://www.ycombinator.com/images/ycombinator-logo-fb889e2e.png" }
  end

  defp get_reddit_info(path) do
    url = "https://www.reddit.com/r/" <> Enum.join(path, "/")
    { :ok, response } = HTTPoison.get(url, [], [follow_redirect: true, timeout: 10_000])
    resource = Floki.find(response.body, ".nestedlisting .entry") |> List.first

    title = Floki.find(response.body, ".title.may-blank") |> Floki.text
    text = Floki.find(resource, ".usertext-body") |> Floki.raw_html
    by = Floki.find(resource, ".author") |> Floki.text

    %{ title: title, content: text, by: by, image: "https://www.redditstatic.com/circled-snoo-1x.png" }
  end

end