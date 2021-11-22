const InternetImageLegend = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-internet-image-legend", {legend: this.el.innerText,  id: this.el.dataset.mediaId});
    });
  }
}

export default InternetImageLegend
