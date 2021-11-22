const FrameLegend = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-frame-legend", {legend: this.el.innerText,  id: this.el.dataset.mediaId});
    });
  }
}

export default FrameLegend
