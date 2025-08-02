defmodule TamnoonTtt.Components.Root do
  @behaviour Tamnoon.Component

  @impl true
  def heex do
    ~s"""
    <!DOCTYPE html>
    <html lang="en">

      <head>
        <meta name="description" content="Webpage description goes here" />
        <meta charset="utf-8">
        <title>Tamnoon Tic-Tac-Toe</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="tamnoon/tamnoon_dom.js"></script>
        <script src="tamnoon/tamnoon_driver.js"></script>
        <link rel="icon" type="image/x-icon" href="/tamnoon/tamnoon_icon.ico">
        <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
      </head>

      <body>
          <h1>Welcome to your Tamnoon app!</h1>
      </body>
    </html>
    """
  end
end
