# ShareLike.Pro

This is an experimental project to see how well Elixir ⚗️ can handle long-running requests.

## How it works 😎

- chrome extension injects a link to every comment on the page
- when clicked, it makes request to the server which fetches the permalink page with the comment
- server generates and renders a preview using internal nice-looking comment template
- this rendered template is passed to the command utility which returns an image from the HTML template
- the image gets posted on Twitter along with user comment
