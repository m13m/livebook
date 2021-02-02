defmodule LiveBookWeb.Section do
  use LiveBookWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="<%= if not @selected, do: "hidden" %>">
      <div class="flex justify-between items-center">
        <div class="flex space-x-2 items-center text-gray-600">
          <%= Icons.svg(:chevron_right, class: "h-8") %>
          <h2 id="section-<%= @section.id %>-name"
              contenteditable
              spellcheck="false"
              phx-blur="set_section_name"
              phx-value-section_id="<%= @section.id %>"
              phx-hook="ContentEditable"
              data-update-attribute="phx-value-name"
              class="text-3xl"><%= @section.name %></h2>
        </div>
        <div class="flex space-x-2 items-center">
          <button phx-click="delete_section" phx-value-section_id="<%= @section.id %>" class="text-gray-600 hover:text-current">
            <%= Icons.svg(:trash, class: "h-6") %>
          </button>
        </div>
      </div>
      <div class="container py-4">
        <div class="flex flex-col space-y-2 pb-80">
          <%= live_component @socket, LiveBookWeb.InsertCellActions,
                             id: "#{@section.id}:0",
                             section_id: @section.id,
                             index: 0 %>
          <%= for {cell, index} <- Enum.with_index(@section.cells) do %>
            <%= live_component @socket, LiveBookWeb.Cell,
                               id: cell.id,
                               cell: cell,
                               cell_info: @cell_infos[cell.id],
                               focused: @selected and cell.id == @focused_cell_id,
                               expanded: @selected and cell.id == @focused_cell_id and @focused_cell_expanded %>
            <%= live_component @socket, LiveBookWeb.InsertCellActions,
                               id: "#{@section.id}:#{index + 1}",
                               section_id: @section.id,
                               index: index + 1 %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end