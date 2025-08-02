defmodule TamnoonTtt.Utils.PageManagement do
  alias Tamnoon.DOM

  @doc """
  Replaces the page container with one containing the new page.
  """
  @spec switch_page_action(new_page_path :: String.t()) :: Tamnoon.DOM.Actions.ReplaceNode.t()
  def switch_page_action(new_page_path), do:
    DOM.Actions.ReplaceNode.new!(%{
      target: DOM.Node.new!(%{
        selector_type: :id,
        selector_value: "page-container"
      }),
      replacement: DOM.Node.new!(%{
        selector_type: :from_string,
        selector_value:
        """
        <div id="page-container">
          #{Tamnoon.Compiler.render_component(new_page_path, %{}, true)}
        </div>
        """
      })
    })
end
