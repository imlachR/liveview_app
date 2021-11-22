const VideoLegend = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-video-legend", {legend: this.el.innerText,  id: this.el.dataset.mediaId});
    });
  }
}

export default VideoLegend
