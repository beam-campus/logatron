defmodule LogatronWeb.PageController do
  use LogatronWeb, :controller

  alias LogatronWeb.Router.Helpers, as: Routes


  def home(conn, _params) do
    redirect(conn, to: "/world")
  end

  
end
