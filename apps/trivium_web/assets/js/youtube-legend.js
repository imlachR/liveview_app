const YoutubeLegend = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-youtube-legend", {legend: this.el.innerText,  id: this.el.dataset.mediaId});
    });
  }
}

export default YoutubeLegend
