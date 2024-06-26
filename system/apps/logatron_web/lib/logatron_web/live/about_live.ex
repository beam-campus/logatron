defmodule LogatronWeb.AboutLive do
  use LogatronWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center lt-view-gradient">
    <div class="items-center justify-center block">
    <h1 class="text-2xl font-normal text-white font-brand" >
      Terminal Operations as a Service
    </h1>
    </div>
    </div>

    <div class="flex flex-col text-white font-brand">

    <%!-- <div class="flex-grow"> --%>

    <div class="lt-section-text" id="about_top_text">

    Logatron is a customizable SaaS platform that supports operations
    for any combination of cargo types and transport modes.
    With extended support for yard operations, resource planning, and intelligent reporting tools,
    Logatron empowers you to make informed decisions and increase productivity.
        <br/>
    </div>

    <div id="about_section_1">
    <div class="lt-section-header" id="about_text_1">
        A Modular Solution for Diverse Needs
    </div>
    <div class="flex">
    <div class="w-1/2">
    <img src="/images/logistics.jpg" alt="About 1" class="w-full p-4" />
    </div>
    <div class="w-1/2">
    <div class="lt-section-text">
    No two terminals are alike, and your operational needs are unique.
    Logatron.io offers a highly customizable platform that allows you to activate only the functionalities
    relevant to your specific operations. Whether you're handling container transfers between trains and
    seagoing vessels or managing a complex mix of cargo types and transport modes,
    our platform adapts to fit your requirements.
    This tailored approach ensures that you only pay for the features you need,
    maximizing both efficiency and cost-effectiveness.
        <br/>
    </div>
    </div>
    </div>
    </div>

     <div class="lt-section-header" id="about_text_2">
       Reliable, Secure and Transparent Operations with Confidence
     </div>
       <div class="lt-section-text">
       Uninterrupted operations are crucial in the logistics industry.
       That's why we build further upon battle-proven technology that guarantees high availability and absolute traceability.
       We literally put a flight recorder on your terminal operations, a feature that is unique to Logatron.
       This level of transparency empowers you to resolve disputes quickly and confidently, with clear evidence to support your case.

        <br/>
       </div>

    <div class="lt-section-header" id="about_text_3">
        Terminal Operations for the Future
    </div>
    <div class="lt-section-text">
    Choose Logatron.io to elevate your terminal operations with unmatched reliability,
    traceability, and security. Our battle-tested platform reduces risks,
    enhances efficiency, and empowers you to manage your logistics terminal confidently.
    Experience the difference Logatron can make for your business as you discover the future of terminal management.
    Explore our features, schedule a demo, and revolutionize your operations today.
        <br/>
    </div>



    <%!-- </div>     --%>
    </div>



    """
  end
end
