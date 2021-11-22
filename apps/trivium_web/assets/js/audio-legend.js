const AudioLegend = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-audio-legend", {legend: this.el.innerText,  id: this.el.dataset.mediaId});
    });
  }
}

export default AudioLegend
