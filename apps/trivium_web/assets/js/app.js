// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

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
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let Uploaders = {}

Uploaders.S3 = function(entries, onViewError){
  entries.forEach(entry => {
    let formData = new FormData()
    let {url, fields} = entry.meta
    Object.entries(fields).forEach(([key, val]) => formData.append(key, val))
    formData.append("file", entry.file)
    let xhr = new XMLHttpRequest()
    onViewError(() => xhr.abort())
    xhr.onload = () => xhr.status === 204 || entry.error()
    xhr.onerror = () => entry.error()
    xhr.upload.addEventListener("progress", (event) => {
      if(event.lengthComputable){
        let percent = Math.round((event.loaded / event.total) * 100)
        entry.progress(percent)
      }
    })

    xhr.open("POST", url, true)
    xhr.send(formData)
  })
}

import Quiz from "./quiz"
import QuizText from "./quiz-text"
import Container from "./container"
import Writer from "./writer"
import Position from "./position"
import Name from "./name"
import Canvas from "./canvas"
import ImageLegend from "./image-legend"
import YoutubeLegend from "./youtube-legend"
import FrameLegend from "./frame-legend"
import InternetImageLegend from "./internet-image-legend"
import VideoLegend from "./video-legend"
import AudioLegend from "./audio-legend"
import Locale from "./locale"
import Profile from "./profile"
import Cubes from "./cubes"
import Question from "./question"
import Score from "./score"

let Hooks = {
  Quiz: Quiz,
  QuizText: QuizText,
  Container: Container,
  Writer: Writer,
  Position: Position,
  Name: Name,
  Canvas: Canvas,
  ImageLegend: ImageLegend,
  YoutubeLegend: YoutubeLegend,
  FrameLegend: FrameLegend,
  InternetImageLegend: InternetImageLegend,
  VideoLegend: VideoLegend,
  AudioLegend: AudioLegend,
  Locale: Locale,
  Profile: Profile,
  Cubes: Cubes,
  Question: Question,
  Score: Score
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  uploaders: Uploaders,
  hooks: Hooks,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

var inp = document.getElementsByClassName('profile-input');
// console.log(inp.photo.id);
