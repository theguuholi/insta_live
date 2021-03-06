// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"
import "../node_modules/materialize-css/dist/js/materialize";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {
    Socket
} from "phoenix"
import topbar from "topbar"
import {
    LiveSocket
} from "phoenix_live_view"

let Hooks = {};
Hooks.ScrollPosts = {
    mounted() {
        // invocado quando e adicionado no DOM
        // this.el fala qual e o elemento
        console.log("mounted", this.el);
         this.observer = new IntersectionObserver(entries => {
            console.log(entries)
            const entry = entries[0];
            if( entry.isIntersecting){
                console.log("visible")
                // chama evento no liveview
                this.pushEvent("load-posts", {a: 1});
            }
        });
        // notifica qunado o elemento esta na tela
        this.observer.observe(this.el);
    },
    updated(){
        // e chamado quando elemento e atualizado pelo liveview
        const pageNumber = this.el.dataset.pageNumber;
        console.log("updated", pageNumber);
    },
    destroyed(){
        this.observer.disconnect();
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    params: {
        _csrf_token: csrfToken
    },
    hooks: Hooks
})

document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.dropdown-trigger');
    var instances = M.Dropdown.init(elems, {});
  });

// Show progress bar on live navigation and form submits
topbar.config({
    barColors: {
        0: "#29d"
    },
    shadowColor: "rgba(0, 0, 0, .3)"
})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
