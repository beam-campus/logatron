defmodule LogatronWeb.Layouts.App do
  @moduledoc """
  This layout is used for the main layout of the application.
  """
  alias Phoenix.LiveView.JS

  def toggle_dropdown_menu do
    JS.toggle(to: "#dropdown_menu")
  end


end
