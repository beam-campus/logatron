// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

const getPixelRatio = context => {
  var backingStore =
    context.backingStorePixelRatio ||
    context.webkitBackingStorePixelRatio ||
    context.mozBackingStorePixelRatio ||
    context.msBackingStorePixelRatio ||
    context.oBackingStorePixelRatio ||
    context.backingStorePixelRatio ||
    1;

  return (window.devicePixelRatio || 1) / backingStore;
};

const fade = (canvas, context, amount) => {
  context.beginPath();
  context.rect(0, 0, canvas.width, canvas.height);
  context.fillStyle = `rgba(255, 255, 255, ${amount})`;
  context.fill();
};

const resize = (canvas, ratio) => {
  canvas.width = window.innerWidth * ratio;
  canvas.height = window.innerHeight * ratio;
  canvas.style.width = `${window.innerWidth}px`;
  canvas.style.height = `${window.innerHeight}px`;
};

const cubehelix = (s, r, h) => d => {
  let t = 2 * Math.PI * (s / 3 + r * d);
  let a = (h * d * (1 - d)) / 2;
  return [
    d + a * (-0.14861 * Math.cos(t) + Math.sin(t) * 1.78277),
    d + a * (-0.29227 * Math.cos(t) + Math.sin(t) * -0.90649),
    d + a * (1.97294 * Math.cos(t) + Math.sin(t) * 0.0)
  ];
};

let hooks = {
  canvas: {
    mounted() {
      let canvas = this.el.firstElementChild;
      let context = canvas.getContext("2d");
      let ratio = getPixelRatio(context);
      let colorizer = cubehelix(3, 0.5, 2.0);

      resize(canvas, ratio);

      Object.assign(this, {
        canvas,
        colorizer,
        context,
        ratio,
        i: 0,
        j: 0,
        fps: 0,
        ups: 0
      });
    },
    updated() {
      let { canvas, colorizer, context, ratio } = this;
      let cell_states = JSON.parse(this.el.dataset.cell_states);

      let halfHeight = canvas.height / 2;
      let halfWidth = canvas.width / 2;
      let smallerHalf = Math.min(halfHeight, halfWidth);

      this.j++;
      if (this.j % 5 === 0) {
        this.j = 0;
        let now = performance.now();
        this.ups = 1 / ((now - (this.upsNow || now)) / 5000);
        this.upsNow = now;
      }

      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;

        fade(canvas, context, 0.5);
        cell_states.forEach(([state]) => {
          let [r, g, b] = colorizer(state);
          
          context.fillStyle = `rgb(${r * 255}, ${g * 255}, ${b * 255})`;
          context.beginPath();
          context.arc(
            halfWidth + x * smallerHalf,
            halfHeight + y * smallerHalf,
            a * (smallerHalf / 16),
            0,
            2 * Math.PI
          );
          context.fill();
          
        });

        this.i++;
        if (this.i % 5 === 0) {
          this.i = 0;
          let now = performance.now();
          this.fps = 1 / ((now - (this.fpsNow || now)) / 5000);
          this.fpsNow = now;
        }
        context.textBaseline = "top";
        context.font = "20pt monospace";
        context.fillStyle = "#f0f0f0";
        context.beginPath();
        context.rect(0, 0, 260, 80);
        context.fill();
        context.fillStyle = "black";
        context.fillText(`Client FPS: ${Math.round(this.fps)}`, 10, 10);
        context.fillText(`Server FPS: ${Math.round(this.ups)}`, 10, 40);
      });
    }
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: hooks,
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

